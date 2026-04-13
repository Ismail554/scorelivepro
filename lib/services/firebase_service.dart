import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('--- Push Notification Received (Background) ---');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Payload: ${message.data}');

  // If the push message only contains 'data' (no 'notification' payload),
  // Android/iOS won't show it automatically in the background. 
  // We must handle this manually to ensure it appears.
  if (message.notification == null && (message.data['title'] != null || message.data['body'] != null)) {
    await FirebaseService.showBackgroundDataNotification(message);
  }
}

class FirebaseService {
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  /// Flutter Local Notifications plugin instance
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Android notification channel for high-importance foreground notifications
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'scorelive_high_importance_channel', // Must match AndroidManifest channel id
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
  );

  /// Whether the last FCM token fetch failed (SERVICE_NOT_AVAILABLE etc.)
  static bool fcmTokenFailed = false;
  static String? lastFcmError;

  // function to initialize notifications
  Future<void> initNotifications() async {
    try {
      // Request battery optimization exemption on Android (OnePlus/Redmi fix)
      // Made optional per developer request to improve UX on startup
      /* 
      if (Platform.isAndroid) {
        await _requestBatteryOptimizationExemption();
      }
      */

      // request permission from user
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Initialize local notifications for foreground display
      await _initLocalNotifications();

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

  /// Initialize flutter_local_notifications and create the Android channel
  Future<void> _initLocalNotifications() async {
    // Android initialization
    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          handleMessage(RemoteMessage(data: data));
        }
      },
    );

    // Create the notification channel on Android
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Show a local notification (real status bar notification with sound + vibration)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    
    // Extract title and body from notification payload or fallback to data payload
    final String? title = notification?.title ?? data['title'];
    final String? body = notification?.body ?? data['body'];

    if (title == null && body == null) {
      // Nothing to show if both are completely empty
      return;
    }

    // iOS natively shows foreground popups ONLY if it is a Notification Payload (notification != null).
    // If it's a Data-only payload (notification == null), iOS will NOT show it natively,
    // so we must manually show it using flutter_local_notifications for BOTH Android and iOS!
    if (Platform.isIOS && notification != null) {
        return; 
    }

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500, 200, 500]),
      icon: '@drawable/ic_notification',
      ticker: title,
      styleInformation: BigTextStyleInformation(
        body ?? '',
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: notification?.hashCode ?? data.hashCode, // unique id
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  /// Manually shows a local notification in the background isolate
  /// for data-only messages where the OS will not natively display it.
  static Future<void> showBackgroundDataNotification(RemoteMessage message) async {
    final title = message.data['title'];
    final body = message.data['body'];
    
    if (title == null && body == null) return;

    final plugin = FlutterLocalNotificationsPlugin();
    
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await plugin.initialize(settings: initSettings);

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@drawable/ic_notification',
      ticker: title,
      styleInformation: BigTextStyleInformation(
        body ?? '',
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await plugin.show(
      id: message.data.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: jsonEncode(message.data),
    );
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
  /// Call this manually from UI tests/settings when appropriate.
  Future<void> requestBatteryOptimizationExemption() async {
    if (!Platform.isAndroid) {
      debugPrint("ℹ️ Battery optimization exemption is only managed on Android.");
      return;
    }

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

    // Set foreground notification presentation (iOS)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // foreground notifications — show real system notification with sound & vibration
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('--- Push Notification Received (Foreground) ---');
      
      // Check user preferences before showing
      final isEnabled = await SecureStorageHelper.getNotificationStatus();
      if (!isEnabled) {
        debugPrint('Notification ignored (user disabled in settings)');
        return;
      }

      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Payload: ${message.data}');

      // Show a real system notification in the status bar
      _showLocalNotification(message);
    });
  }
}
