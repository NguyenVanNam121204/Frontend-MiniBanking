export interface AdminRealtimeEvent<T = Record<string, unknown>> {
  eventType: string;
  data: T;
  occurredAt: string;
}

interface StreamAuthContext {
  getAccessToken: () => string | null;
  getRefreshToken: () => string | null;
  onAuthUpdated: (accessToken: string, refreshToken: string) => void;
  onUnauthorized: () => void;
}

interface StreamHandlers {
  onEvent: (event: AdminRealtimeEvent) => void;
  onError?: () => void;
}

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api';

export const startAdminRealtimeStream = (auth: StreamAuthContext, handlers: StreamHandlers) => {
  let active = true;
  let reader: ReadableStreamDefaultReader<Uint8Array> | null = null;
  let abortController: AbortController | null = null;
  let reconnectTimer: number | null = null;

  const scheduleReconnect = () => {
    if (!active) {
      return;
    }

    if (reconnectTimer) {
      window.clearTimeout(reconnectTimer);
    }

    reconnectTimer = window.setTimeout(() => {
      connect();
    }, 2000);
  };

  const processBlock = (block: string) => {
    const lines = block.split('\n');
    let eventName = '';
    const dataLines: string[] = [];

    for (const rawLine of lines) {
      const line = rawLine.trimEnd();
      if (line.startsWith('event:')) {
        eventName = line.slice(6).trim();
      } else if (line.startsWith('data:')) {
        dataLines.push(line.slice(5).trim());
      }
    }

    if (dataLines.length === 0) {
      return;
    }

    try {
      const payload = JSON.parse(dataLines.join('\n')) as AdminRealtimeEvent;
      handlers.onEvent({
        eventType: payload.eventType || eventName || 'UNKNOWN',
        data: payload.data || {},
        occurredAt: payload.occurredAt,
      });
    } catch {
      // Ignore malformed event blocks and keep the stream alive.
    }
  };

  const connect = async () => {
    if (!active) {
      return;
    }

    const token = auth.getAccessToken();
    if (!token) {
      auth.onUnauthorized();
      return;
    }

    abortController?.abort();
    abortController = new AbortController();

    try {
      const response = await fetch(`${API_BASE_URL}/admin/events/stream`, {
        method: 'GET',
        headers: {
          Accept: 'text/event-stream',
          Authorization: `Bearer ${token}`,
          'Cache-Control': 'no-cache',
        },
        signal: abortController.signal,
      });

      if (response.status === 401) {
        const refreshed = await refreshAccessToken(auth);
        if (!refreshed) {
          auth.onUnauthorized();
          return;
        }
        scheduleReconnect();
        return;
      }

      if (!response.ok || !response.body) {
        handlers.onError?.();
        scheduleReconnect();
        return;
      }

      reader = response.body.getReader();
      const decoder = new TextDecoder();
      let buffer = '';

      while (active) {
        const { value, done } = await reader.read();
        if (done) {
          break;
        }

        buffer += decoder.decode(value, { stream: true });
        const blocks = buffer.split('\n\n');
        buffer = blocks.pop() ?? '';

        for (const block of blocks) {
          if (block.trim().length === 0) {
            continue;
          }
          processBlock(block);
        }
      }

      scheduleReconnect();
    } catch {
      if (active) {
        handlers.onError?.();
        scheduleReconnect();
      }
    }
  };

  connect();

  return () => {
    active = false;
    if (reconnectTimer) {
      window.clearTimeout(reconnectTimer);
    }
    abortController?.abort();
    reader?.cancel().catch(() => {});
  };
};

const refreshAccessToken = async (auth: StreamAuthContext) => {
  const refreshToken = auth.getRefreshToken();
  if (!refreshToken) {
    return false;
  }

  try {
    const response = await fetch(`${API_BASE_URL}/auth/refresh-token`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ refreshToken }),
    });

    if (!response.ok) {
      return false;
    }

    const payload = await response.json();
    const nextAccessToken = payload?.data?.accessToken as string | undefined;
    const nextRefreshToken = payload?.data?.refreshToken as string | undefined;

    if (!nextAccessToken || !nextRefreshToken) {
      return false;
    }

    auth.onAuthUpdated(nextAccessToken, nextRefreshToken);
    return true;
  } catch {
    return false;
  }
};
