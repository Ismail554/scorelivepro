import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  WebSocketChannel? _channel;
  ValueNotifier<LiveScoreModel?> liveScoreNotifier = ValueNotifier(null);
  ValueNotifier<bool> isConnected = ValueNotifier(false);

  // Reconnection logic
  int _retryCount = 0;
  Timer? _reconnectTimer;
  String? _lastToken;
  bool _isManuallyClosed = false;

  // Singleton
  static final SocketService instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() => instance;

  /// 🔹 Connect to WebSocket
  Future<void> connectSocket(String token) async {
    _lastToken = token;
    _isManuallyClosed = false;
    
    if (isConnected.value) {
      debugPrint("🔹 WebSocket already connected. Skipping...");
      return;
    }

    debugPrint("🔹 Connecting to WebSocket... (Attempt: ${_retryCount + 1})");

    // Disconnect previous connection if exists
    _closeInternal();

    try {
      final String wsUrl =
          dotenv.env['SOCKET_URL'] ?? "wss://api.scorelivepro.it/ws/live/";
      final uri = Uri.parse(wsUrl);

      Map<String, dynamic> headers = {};
      // Add UUID header
      try {
        final uuid = await SecureStorageHelper.getUuid();
        headers['X-Device-ID'] = uuid;
        log('🆔 Added UUID: $uuid', name: 'HEADER');
      } catch (e) {
        log('⚠️ Failed to add UUID header: $e', name: 'HEADER');
      }

      _channel = IOWebSocketChannel.connect(uri, headers: headers);
      debugPrint("🟢 WebSocket Connection Initiated");

      // Listen to the stream
      _channel!.stream.listen(
        (message) {
          _retryCount = 0; // Reset retry count on successful message
          isConnected.value = true;
          _handleMessage(message);
        },
        onError: (error) {
          debugPrint("⚠️ WebSocket Error: $error");
          isConnected.value = false;
          _handleReconnect();
        },
        onDone: () {
          debugPrint("🔴 WebSocket Disconnected");
          isConnected.value = false;
          if (!_isManuallyClosed) {
            _handleReconnect();
          }
        },
      );
    } catch (e) {
      debugPrint("⚠️ WebSocket Connection Failed: $e");
      isConnected.value = false;
      _handleReconnect();
    }
  }

  void _handleReconnect() {
    if (_isManuallyClosed) return;

    _reconnectTimer?.cancel();
    
    _retryCount++;
    // Exponential backoff: 2s, 4s, 8s, 16s, max 30s
    int delaySeconds = (pow(2, _retryCount).toInt()).clamp(2, 30);
    
    debugPrint("🔄 Scheduling WebSocket reconnection in $delaySeconds seconds...");
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      connectSocket(_lastToken ?? "");
    });
  }

  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        // Only log first 200 chars to avoid console spam, but let us know it arrived.
        debugPrint(
            "📌 WebSocket Message (Preview): ${message.length > 200 ? '${message.substring(0, 200)}...' : message}");

        // Parse specific event types
        if (data is Map<String, dynamic>) {
          // Check for "live_score_update" or generic structure
          if (data['type'] == 'live_score_update' || data['data'] != null) {
            // Sometimes WS sends a single object in "data" instead of a list. Let's wrap it in a list to safely use LiveScoreModel.
            if (data['data'] != null && data['data'] is Map<String, dynamic>) {
              debugPrint(
                  "🔧 Wrapping single data object in a list for LiveScoreModel");
              data['data'] = [data['data']];
            }

            final model = LiveScoreModel.fromJson(data);
            liveScoreNotifier.value = model;

            debugPrint(
                "✅ Successfully parsed LiveScoreModel with ${model.data?.length ?? 0} matches.");
          }
        }
      }
    } catch (e, stack) {
      debugPrint("⚠️ Error parsing WebSocket message: $e");
      debugPrint("⚠️ Stack trace: $stack");
    }
  }

  /// 🔌 Internal close
  void _closeInternal() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    _reconnectTimer?.cancel();
  }

  /// 🔌 Disconnect socket
  void disconnect() {
    _isManuallyClosed = true;
    _closeInternal();
    isConnected.value = false;
    debugPrint("🛑 WebSocket manually closed");
  }
}

// Add power function for backoff
num pow(num x, num y) {
  num result = 1;
  for (int i = 0; i < y; i++) {
    result *= x;
  }
  return result;
}
