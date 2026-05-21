import { create } from 'zustand';

import type { Transaction } from '../services/api/transaction.api';
import type { AdminRealtimeEvent } from '../services/realtime/adminRealtimeStream';

export interface AdminRealtimeNotification {
  id: string;
  transactionId: number;
  referenceNumber: string;
  title: string;
  message: string;
  amount: number;
  createdAt: string;
  unread: boolean;
}

interface AdminRealtimeState {
  notifications: AdminRealtimeNotification[];
  lastEvent: AdminRealtimeEvent | null;
  isConnected: boolean;
  handleRealtimeEvent: (event: AdminRealtimeEvent) => void;
  seedPendingTransactions: (transactions: Transaction[]) => void;
  markAllAsRead: () => void;
  markAsRead: (id: string) => void;
  clearResolvedNotification: (transactionId: number) => void;
  setConnected: (connected: boolean) => void;
}

const buildPendingNotification = (payload: Record<string, unknown>): AdminRealtimeNotification => ({
  id: `pending-${payload.transactionId}`,
  transactionId: Number(payload.transactionId),
  referenceNumber: String(payload.referenceNumber ?? ''),
  title: 'Cần phê duyệt giao dịch lớn',
  message: `Giao dịch ${String(payload.referenceNumber ?? '')} đang chờ admin phê duyệt.`,
  amount: Number(payload.amount ?? 0),
  createdAt: String(payload.createdAt ?? new Date().toISOString()),
  unread: true,
});

export const useAdminRealtimeStore = create<AdminRealtimeState>((set) => ({
  notifications: [],
  lastEvent: null,
  isConnected: false,
  handleRealtimeEvent: (event) =>
    set((state) => {
      if (event.eventType === 'PENDING_TRANSACTION_CREATED') {
        const incoming = buildPendingNotification(event.data);
        const exists = state.notifications.some((item) => item.transactionId === incoming.transactionId);
        return {
          lastEvent: event,
          notifications: exists
              ? state.notifications.map((item) =>
                  item.transactionId === incoming.transactionId ? { ...item, unread: true } : item,
                )
              : [incoming, ...state.notifications],
        };
      }

      if (event.eventType === 'PENDING_TRANSACTION_RESOLVED') {
        return {
          lastEvent: event,
          notifications: state.notifications.filter(
            (item) => item.transactionId !== Number(event.data.transactionId),
          ),
        };
      }

      return { lastEvent: event };
    }),
  seedPendingTransactions: (transactions) =>
    set((state) => {
      const pendingNotifications = transactions
        .filter((tx) => tx.status === 'PENDING')
        .map<AdminRealtimeNotification>((tx) => ({
          id: `pending-${tx.id}`,
          transactionId: tx.id,
          referenceNumber: tx.referenceNumber,
          title: 'Cần phê duyệt giao dịch lớn',
          message: `Giao dịch ${tx.referenceNumber} đang chờ admin phê duyệt.`,
          amount: tx.amount,
          createdAt: tx.createdAt,
          unread: state.notifications.some((item) => item.transactionId === tx.id)
              ? state.notifications.find((item) => item.transactionId === tx.id)?.unread ?? true
              : true,
        }));

      return { notifications: pendingNotifications };
    }),
  markAllAsRead: () =>
    set((state) => ({
      notifications: state.notifications.map((item) => ({ ...item, unread: false })),
    })),
  markAsRead: (id) =>
    set((state) => ({
      notifications: state.notifications.map((item) =>
        item.id === id ? { ...item, unread: false } : item,
      ),
    })),
  clearResolvedNotification: (transactionId) =>
    set((state) => ({
      notifications: state.notifications.filter((item) => item.transactionId !== transactionId),
    })),
  setConnected: (connected) => set({ isConnected: connected }),
}));
