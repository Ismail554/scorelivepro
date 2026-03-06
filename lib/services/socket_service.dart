import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  WebSocketChannel? _channel;
  ValueNotifier<LiveScoreModel?> liveScoreNotifier = ValueNotifier(null);

  // Singleton
  static final SocketService instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() => instance;

  /// 🔹 Connect to WebSocket
  Future<void> connectSocket(String token) async {
    print("🔹 Connecting to WebSocket...");

    // Disconnect previous connection if exists
    disconnect();

    try {
      final uri = Uri.parse("wss://api.scorelivepro.it/ws/live/");

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
        // Only log first 200 chars to avoid console spam, but let us know it arrived.
        print(
            "📌 WebSocket Message (Preview): ${message.length > 200 ? message.substring(0, 200) + '...' : message}");

        // Parse specific event types
        if (data is Map<String, dynamic>) {
          // Check for "live_score_update" or generic structure
          if (data['type'] == 'live_score_update' || data['data'] != null) {
            // Sometimes WS sends a single object in "data" instead of a list. Let's wrap it in a list to safely use LiveScoreModel.
            if (data['data'] != null && data['data'] is Map<String, dynamic>) {
              print(
                  "🔧 Wrapping single data object in a list for LiveScoreModel");
              data['data'] = [data['data']];
            }

            final model = LiveScoreModel.fromJson(data);
            liveScoreNotifier.value = model;

            print(
                "✅ Successfully parsed LiveScoreModel with ${model.data?.length ?? 0} matches.");
          }
        }
      }
    } catch (e, stack) {
      print("⚠️ Error parsing WebSocket message: $e");
      print("⚠️ Stack trace: $stack");
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
