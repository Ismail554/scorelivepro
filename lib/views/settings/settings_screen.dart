import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/views/auth/login_screen.dart';
import 'package:scorelivepro/views/settings/app_info_screen.dart';
import 'package:scorelivepro/views/settings/language_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/provider/notification_provider.dart';
import 'package:scorelivepro/views/settings/profile_screen.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final isEnabled = await SecureStorageHelper.getNotificationStatus();
    if (mounted) {
      setState(() {
        _notificationsEnabled = isEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6), // Light Grey BG like image
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        centerTitle: false, // Title left a hobe image er moto
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(
            AppStrings.settings,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoggedIn) {
                return IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure about logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              authProvider.logout();
                              Navigator.pop(context); // Close dialog
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (route) =>
                                    false, // Remove all previous routes to prevent back navigation
                              );
                            },
                            child: const Text("Yes",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  tooltip: AppStrings.signOut,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ACCOUNT SECTION
            _buildSectionHeader(AppStrings.account),
            _buildSettingsGroup(
              children: [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.isLoggedIn) {
                      return _buildSettingsTile(
                        icon: Icons.person_outline,
                        iconColor: const Color(0xFFFF6B00), // Orange Icon
                        iconBgColor: const Color(0xFFFFF1EB), // Light Orange BG
                        title: "User Profile",
                        subtitle: "View and edit profile",
                        showChevron: true,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileScreen()));
                        },
                      );
                    } else {
                      return _buildSettingsTile(
                        icon: Icons.login,
                        iconColor: const Color(0xFFFF6B00), // Orange Icon
                        iconBgColor: const Color(0xFFFFF1EB), // Light Orange BG
                        title: "Login / Sign Up",
                        subtitle: AppStrings.syncFavorites,
                        showChevron: true,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      );
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // 2. PREFERENCES SECTION
            _buildSectionHeader(AppStrings.preferences),
            _buildSettingsGroup(
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: AppStrings.notifications,
                  subtitle:
                      _notificationsEnabled ? AppStrings.enabled : "Disabled",
                  isSwitch: true,
                  switchValue: _notificationsEnabled,
                  onToggle: (val) async {
                    setState(() {
                      _notificationsEnabled = val;
                    });

                    // Call the API
                    final success = await context
                        .read<NotificationProvider>()
                        .registerDevice(val);
                    if (!success && context.mounted) {
                      // Revert if API failed
                      setState(() {
                        _notificationsEnabled = !val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Failed to update notification settings")),
                      );
                    } else if (success) {
                      // Save state locally
                      await SecureStorageHelper.saveNotificationStatus(val);
                    }
                  },
                ),
                _buildDivider(), // Line between items
                _buildSettingsTile(
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "English",
                  showChevron: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LanguageSelectionScreen()));
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // 3. ABOUT SECTION
            _buildSectionHeader(AppStrings.about),
            _buildSettingsGroup(
              children: [
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: AppStrings.appInfo,
                  subtitle: "Version 1.0.0",
                  showChevron: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppInfoScreen()));
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.lock_outline,
                  title: AppStrings.termsOfService,
                  showChevron: true,
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: 40.h),

            // 4. BRANDING & LOGO
            Center(
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00), // Orange Brand Color
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(Icons.emoji_events,
                        color: Colors.white,
                        size: 30.sp), // Placeholder for Logo Asset
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    AppStrings.appName,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppStrings.realScoreNews,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppStrings.copywrite,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // 5. DISCLAIMER BOX (Grey Box at bottom)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBF0), // Darker grey for disclaimer
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                AppStrings.infoDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11.sp, color: Colors.grey[600], height: 1.4),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  // Header Text (ACCOUNT, PREFERENCES...)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // White Card Container that holds the items
  Widget _buildSettingsGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border:
            Border.all(color: Colors.grey.withOpacity(0.1)), // Subtle border
      ),
      child: Column(children: children),
    );
  }

  // Divider Line inside the group
  Widget _buildDivider() {
    return Divider(
        height: 1, thickness: 0.5, indent: 56.w, color: Colors.grey[300]);
  }

  // Single Row Item (The actual Tile)
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color iconColor = const Color(0xFF1C1C1E), // Default Black/Grey
    Color iconBgColor = const Color(0xFFF2F2F7), // Default Light Grey
    bool showChevron = false,
    bool isSwitch = false,
    bool switchValue = false,
    Function(bool)? onToggle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: isSwitch ? () => onToggle?.call(!switchValue) : onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      // Circular Icon
      leading: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: iconBgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
      // Title & Subtitle
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            )
          : null,
      // Right Side Widget (Switch or Arrow)
      trailing: isSwitch
          ? Switch(
              value: switchValue,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFFF6B00), // Orange Switch
              onChanged: onToggle,
            )
          : (showChevron
              ? Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.sp, color: Colors.grey[400])
              : null),
    );
  }
}
