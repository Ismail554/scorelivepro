import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  }

  // fuction to handle recieved notifications

  // function to initialize foreground and background notifications settings
}
