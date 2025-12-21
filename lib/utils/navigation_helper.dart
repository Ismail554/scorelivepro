import 'package:flutter/material.dart';
import 'package:scorelivepro/views/main_navigation/main_navigation_screen.dart';

/// Helper class for navigation with bottom nav bar
class NavigationHelper {
  /// Navigate to main navigation screen with specific tab index
  /// This pops all routes and goes to the main screen with the selected tab
  static void navigateToMainScreen(BuildContext context, int tabIndex) {
    // Pop all routes until we reach the first route (main screen)
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Replace the main screen with a new one that has the selected tab
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainNavigationScreen(initialIndex: tabIndex),
      ),
    );
  }

  /// Get the current tab index from context (if available)
  /// Returns 0 (Matches) as default
  static int getCurrentTabIndex(BuildContext context) {
    // Default to Matches tab (index 0)
    return 0;
  }
}
