import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('--- Push Notification Received (Background) ---');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Payload: ${message.data}');
}

class FirebaseService {
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        // Retry loop
        for (int i = 0; i < 3; i++) {
          await Future<void>.delayed(const Duration(seconds: 3));
          apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken != null) break;
        }
      }

      // If still null, skip FCM token fetch to prevent crash
      if (apnsToken == null) {
        debugPrint(
            "APNS Token not available after retries. Skipping FCM token fetch.");
        return;
      }
    }

    // fetch the FCM token for this device
    final FCMToken = await _firebaseMessaging.getToken();
    // print the token
    debugPrint("FCM Token: $FCMToken");

    initPushNotifications();
  }

  // fuction to handle recieved notifications
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    debugPrint('--- Navigating to Notification from Push ---');
    debugPrint('Payload: ${message.data}');
    // Navigation or handling logic can be added here
  }

  // function to initialize foreground and background notifications settings
  Future<void> initPushNotifications() async {
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // attach background foreground handler
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('--- Push Notification Received (Foreground) ---');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Payload: ${message.data}');
    });
  }
}
