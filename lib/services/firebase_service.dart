import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('--- Push Notification Received (Background) ---');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseService {
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission();

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
        print(
            "APNS Token not available after retries. Skipping FCM token fetch.");
        return;
      }
    }

    // fetch the FCM token for this device
    final FCMToken = await _firebaseMessaging.getToken();
    // print the token
    print("FCM Token: " + FCMToken.toString());

    initPushNotifications();
  }

  // fuction to handle recieved notifications
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    print('--- Navigating to Notification from Push ---');
    print('Payload: ${message.data}');
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
      print('--- Push Notification Received (Foreground) ---');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Payload: ${message.data}');
    });
  }
}
