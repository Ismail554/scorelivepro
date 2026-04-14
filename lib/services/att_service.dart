import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';

/// Handles the App Tracking Transparency (ATT) prompt required by Apple for
/// apps using ad networks (Guideline 5.1.2).
/// On Android, this is a no-op (does nothing and returns safely).
class ATTService {
  static final ATTService _instance = ATTService._internal();
  factory ATTService() => _instance;
  ATTService._internal();

  /// Requests tracking authorization from the user on iOS 14+.
  /// Should be called BEFORE initializing Google Mobile Ads.
  /// Safe to call on Android – it will simply return immediately.
  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) return;

    try {
      final status =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      debugPrint('[ATT] Current tracking status: $status');

      // Only show the prompt if not yet determined
      if (status == TrackingStatus.notDetermined) {
        // A small delay is recommended by Apple to ensure the app is fully loaded
        // before presenting the permission dialog.
        await Future.delayed(const Duration(milliseconds: 500));
        final newStatus =
            await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('[ATT] New tracking status after request: $newStatus');
      }
    } catch (e) {
      // Fail silently – ads can still show without tracking, just non-personalized.
      debugPrint('[ATT] Error requesting tracking authorization: $e');
    }
  }

  /// Returns the current tracking authorization status.
  /// Returns [TrackingStatus.notSupported] on Android.
  Future<TrackingStatus> getTrackingStatus() async {
    if (!Platform.isIOS) return TrackingStatus.notSupported;
    return await AppTrackingTransparency.trackingAuthorizationStatus;
  }
}
