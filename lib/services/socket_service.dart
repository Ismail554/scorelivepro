import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  String? _token;
  ValueNotifier<LiveScoreModel?> liveScoreNotifier = ValueNotifier(null);

  // Singleton
  static final SocketService instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() => instance;

  /// 🔹 Connect socket with token
  void connectSocket(String token) {
    _token = token;
    print("🔹 Connecting Socket with token: $token");

    // Disconnect previous socket if exists
    if (socket != null) {
      socket!.disconnect();
      socket = null;
      print("🔴 Previous socket disconnected");
    }

    // Extract base URL and convert to WebSocket URL
    final baseUrl = ApiEndPoint.baseUrl;

    // Create new socket connection with proper auth format
    socket = IO.io(
      "wss://api.scorelivepro.it/ws/live/",
      // baseUrl,
      // "https://marvella-shakier-leon.ngrok-free.dev/socket.io/",
      IO.OptionBuilder()
          .setPath('/socket.io/')
          .setTransports(['websocket'])
          .enableForceNew()
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(1000)
          .setReconnectionDelay(1000)
          .setAuth({
            'token': 'Bearer $_token',
          }) // Auth format as per backend requirements
          .setExtraHeaders({
            "Authorization": "Bearer $_token",
          }) // Also in headers
          .build(),
    );

    // Socket events
    socket!.onConnect((_) {
      print("🟢 Socket Connected");
      _sendToken();
    });

    /// 🔹 Stop listening to a server event
    socket!.onReconnect((attempt) {
      print("🔄 Socket Reconnected → Attempt: $attempt");
      _sendToken();
    });

    socket!.onDisconnect((reason) {
      print("🔴 Socket Disconnected: $reason");
    });

    socket!.onConnectError((error) {
      print("⚠️ Socket Connect Error: $error");
    });

    socket!.onError((error) {
      print("⚠️ Socket Error: $error");
    });

    // Start listening to live matches immediately
    listenToLiveMatches();
  }

  /// 🔹 Send token to server
  void _sendToken() {
    if (_token != null && socket != null && socket!.connected) {
      socket!.emit("update_token", {"token": _token});
      print("📡 Token sent: $_token");
    }
  }

  /// 🔹 Stop listening to a server event
  void offEvent(String eventName) {
    if (socket != null) {
      socket!.off(eventName);
      print("📌 Stopped listening to event: $eventName");
    }
  }

  /// 🔹 Update token at runtime
  void updateToken(String newToken) {
    _token = newToken;
    print("🔄 Token updated: $newToken");
    _sendToken();
  }

  void sendMessageWithAck(
    String message,
    String toUserId,
    Function(bool) onResult,
  ) {
    if (socket != null && socket!.connected) {
      try {
        final data = {"message": message, "to_user": toUserId};
        socket!.emitWithAck(
          "send_message",
          data,
          ack: (ackData) {
            if (ackData != null && ackData['status'] == 'ok') {
              onResult(true);
            } else {
              onResult(false);
            }
          },
        );
      } catch (e) {
        onResult(false);
      }
    } else {
      onResult(false);
    }
  }

  /// 🔹 Listen to live matches
  void listenToLiveMatches() {
    if (socket != null) {
      socket!.on('live_data', (data) {
        try {
          print("📌 Live Match Data Received: $data");
          if (data != null && data is Map<String, dynamic>) {
            liveScoreNotifier.value = LiveScoreModel.fromJson(data);
          }
        } catch (e) {
          print("⚠️ Error parsing live match data: $e");
        }
      });
      print("📌 Listening to event: live_data");
    }
  }

  /// 🔹 Listen to server events
  void onEvent(String eventName, Function(dynamic) callback) {
    if (socket != null) {
      socket!.on(eventName, callback);
      print("📌 Listening to event: $eventName");
    }
  }

  /// 🔌 Disconnect socket
  void disconnect() {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
      print("🛑 Socket manually disconnected");
    }
  }
}
