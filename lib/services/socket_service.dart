import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  WebSocketChannel? _channel;
  ValueNotifier<LiveScoreModel?> liveScoreNotifier = ValueNotifier(null);

  // Singleton
  static final SocketService instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() => instance;

  /// 🔹 Connect to WebSocket
  void connectSocket(String token) {
    // Note: token is accepted but ignored if not needed for URL params
    // If the server expected headers, we'd add them here.
    // Based on requirements, we are connecting without auth headers for now.

    print("🔹 Connecting to WebSocket...");

    // Disconnect previous connection if exists
    disconnect();

    try {
      final uri = Uri.parse("wss://api.scorelivepro.it/ws/live/");
      _channel = WebSocketChannel.connect(uri);
      print("🟢 WebSocket Connection Initiated");

      // Listen to the stream
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print("⚠️ WebSocket Error: $error");
        },
        onDone: () {
          print("🔴 WebSocket Disconnected");
        },
      );
    } catch (e) {
      print("⚠️ WebSocket Connection Failed: $e");
    }
  }

  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        print("📌 WebSocket Message: $data");

        // Parse specific event types
        if (data is Map<String, dynamic>) {
          // Check for "live_score_update" or generic structure
          if (data['type'] == 'live_score_update' || data['data'] != null) {
            // The model expects the whole JSON or just the data part?
            // Looking at LiveScoreModel.fromJson: it expects 'type' and 'data'.
            // The screenshot shows {"type": "live_score_update", "data": [...]}
            // So we pass the whole map.
            liveScoreNotifier.value = LiveScoreModel.fromJson(data);
          }
        }
      }
    } catch (e) {
      print("⚠️ Error parsing WebSocket message: $e");
    }
  }

  /// 🔌 Disconnect socket
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
      print("🛑 WebSocket manually closed");
    }
  }
}
