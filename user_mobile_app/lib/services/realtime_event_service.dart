import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'storage_service.dart';

class RealtimeEvent {
  final String eventType;
  final Map<String, dynamic> data;
  final DateTime occurredAt;

  const RealtimeEvent({
    required this.eventType,
    required this.data,
    required this.occurredAt,
  });
}

class RealtimeEventService {
  final StorageService _storageService;
  final StreamController<RealtimeEvent> _controller = StreamController<RealtimeEvent>.broadcast();

  HttpClient? _httpClient;
  StreamSubscription<String>? _lineSubscription;
  Timer? _reconnectTimer;
  bool _isRunning = false;
  bool _isConnecting = false;

  RealtimeEventService(this._storageService);

  Stream<RealtimeEvent> get events => _controller.stream;

  Future<void> startUserStream() async {
    if (_isRunning || _isConnecting) {
      return;
    }

    _isRunning = true;
    await _connect();
  }

  Future<void> stop() async {
    _isRunning = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _lineSubscription?.cancel();
    _lineSubscription = null;
    _httpClient?.close(force: true);
    _httpClient = null;
  }

  Future<void> _connect() async {
    if (!_isRunning || _isConnecting) {
      return;
    }

    _isConnecting = true;
    try {
      final accessToken = await _storageService.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        _scheduleReconnect();
        return;
      }

      final baseUrl = dotenv.get('BASE_URL', fallback: 'http://localhost:8080/api');
      final uri = Uri.parse('$baseUrl/notifications/stream');

      _httpClient?.close(force: true);
      _httpClient = HttpClient()..connectionTimeout = const Duration(seconds: 20);

      final request = await _httpClient!.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'text/event-stream');
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');

      final response = await request.close();
      if (response.statusCode == 401) {
        final refreshed = await _refreshAccessToken(baseUrl);
        if (refreshed) {
          _scheduleReconnect();
          return;
        }
      }

      if (response.statusCode != 200) {
        _scheduleReconnect();
        return;
      }

      String? eventName;
      final dataLines = <String>[];

      await _lineSubscription?.cancel();
      _lineSubscription = response
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          if (line.isEmpty) {
            _emitEvent(eventName, dataLines);
            eventName = null;
            dataLines.clear();
            return;
          }

          if (line.startsWith('event:')) {
            eventName = line.substring(6).trim();
            return;
          }

          if (line.startsWith('data:')) {
            dataLines.add(line.substring(5).trim());
          }
        },
        onDone: _scheduleReconnect,
        onError: (_) => _scheduleReconnect(),
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _emitEvent(String? eventName, List<String> dataLines) {
    if (dataLines.isEmpty) {
      return;
    }

    try {
      final rawPayload = dataLines.join('\n');
      final decoded = jsonDecode(rawPayload) as Map<String, dynamic>;
      final eventType = (decoded['eventType'] ?? eventName ?? 'UNKNOWN').toString();
      final data = decoded['data'] is Map<String, dynamic>
          ? decoded['data'] as Map<String, dynamic>
          : <String, dynamic>{};
      final occurredAt = DateTime.tryParse((decoded['occurredAt'] ?? '').toString()) ?? DateTime.now();

      _controller.add(
        RealtimeEvent(
          eventType: eventType,
          data: data,
          occurredAt: occurredAt,
        ),
      );
    } catch (_) {
      // Ignore malformed events and keep stream alive.
    }
  }

  void _scheduleReconnect() {
    if (!_isRunning) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 2), () {
      if (_isRunning) {
        _connect();
      }
    });
  }

  Future<bool> _refreshAccessToken(String baseUrl) async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    HttpClient? refreshClient;
    try {
      refreshClient = HttpClient()..connectionTimeout = const Duration(seconds: 15);
      final request = await refreshClient.postUrl(Uri.parse('$baseUrl/auth/refresh-token'));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(utf8.encode(jsonEncode({'refreshToken': refreshToken})));

      final response = await request.close();
      if (response.statusCode != 200) {
        return false;
      }

      final raw = await response.transform(utf8.decoder).join();
      final payload = jsonDecode(raw) as Map<String, dynamic>;
      final data = payload['data'] as Map<String, dynamic>?;
      final newAccessToken = data?['accessToken']?.toString();
      final newRefreshToken = data?['refreshToken']?.toString();

      if (newAccessToken == null || newRefreshToken == null) {
        return false;
      }

      await _storageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      refreshClient?.close(force: true);
    }
  }
}
