import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission();
    // fetch the FCM token for this device
    final FCMToken = await _firebaseMessaging.getToken();
    // print the token
    print("FCM Token: " + FCMToken.toString());
  }

  // fuction to handle recieved notifications

  // function to initialize foreground and background notifications settings
}
