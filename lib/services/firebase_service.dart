import 'dart:io';
import 'dart:math';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
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

  /// Whether the last FCM token fetch failed (SERVICE_NOT_AVAILABLE etc.)
  static bool fcmTokenFailed = false;
  static String? lastFcmError;

  // function to initialize notifications
  Future<void> initNotifications() async {
    try {
      // Request battery optimization exemption on Android (OnePlus/Redmi fix)
      if (Platform.isAndroid) {
        await _requestBatteryOptimizationExemption();
      }

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
          fcmTokenFailed = true;
          lastFcmError = "APNS Token not available";
          // Still set up push listeners for when token becomes available
          initPushNotifications();
          return;
        }
      }

      // Fetch FCM token with exponential backoff retry
      final fcmToken = await _getTokenWithRetry();

      if (fcmToken != null) {
        debugPrint("FCM Token: $fcmToken");
        fcmTokenFailed = false;
        lastFcmError = null;
      } else {
        debugPrint("⚠️ Failed to get FCM token after all retries.");
        fcmTokenFailed = true;
        // lastFcmError is set inside _getTokenWithRetry
      }

      // Always set up push notification listeners, even if token fetch failed.
      // The token might become available later (e.g., after Google Play Services update).
      initPushNotifications();
    } catch (e) {
      debugPrint("Error initializing notifications: $e");
      fcmTokenFailed = true;
      lastFcmError = e.toString();
      // Still try to set up push listeners
      try {
        initPushNotifications();
      } catch (_) {}
    }
  }

  /// Fetch FCM token with exponential backoff (retries up to 3 times).
  /// Handles SERVICE_NOT_AVAILABLE gracefully on OnePlus/Redmi devices.
  Future<String?> _getTokenWithRetry({int maxRetries = 3}) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final token = await _firebaseMessaging.getToken();
        if (token != null && token.isNotEmpty) {
          return token;
        }
      } catch (e) {
        final errorStr = e.toString();
        lastFcmError = errorStr;
        debugPrint(
            "⚠️ FCM getToken attempt ${attempt + 1}/${maxRetries + 1} failed: $errorStr");

        // If it's the last attempt, don't wait
        if (attempt < maxRetries) {
          // Exponential backoff: 2s, 4s, 8s
          final delay = Duration(seconds: pow(2, attempt + 1).toInt());
          debugPrint("⏳ Retrying in ${delay.inSeconds}s...");
          await Future<void>.delayed(delay);
        }
      }
    }
    return null;
  }

  /// Request battery optimization exemption on Android.
  /// This is critical for OnePlus, Redmi/Xiaomi, Oppo, Huawei devices
  /// that aggressively kill background services including Google Play Services.
  Future<void> _requestBatteryOptimizationExemption() async {
    try {
      final isBatteryOptimizationDisabled =
          await DisableBatteryOptimization.isBatteryOptimizationDisabled;

      if (isBatteryOptimizationDisabled != null &&
          !isBatteryOptimizationDisabled) {
        debugPrint(
            "🔋 Battery optimization is ON. Requesting exemption...");
        await DisableBatteryOptimization
            .showDisableBatteryOptimizationSettings();
      } else {
        debugPrint("✅ Battery optimization is already disabled for this app.");
      }
    } catch (e) {
      debugPrint("⚠️ Could not check/request battery optimization: $e");
      // Non-fatal — continue with initialization
    }
  }

  // function to handle received notifications
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

    // Listen for token refresh (important: token may arrive later after retry failure)
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint("🔄 FCM Token refreshed: $newToken");
      fcmTokenFailed = false;
      lastFcmError = null;
    });

    // foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('--- Push Notification Received (Foreground) ---');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Payload: ${message.data}');
    });
  }
}
