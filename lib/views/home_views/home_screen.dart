import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            //Top bg part
            SizedBox(
              height: 180.h,
              width: double.maxFinite,
              child: Stack(
                children: [
                  /// Background Image
                  Positioned.fill(
                      child: Image.asset(
                    ImageAssets.home_bg,
                    fit: BoxFit.cover,
                  )),

                  /// 🌑 Dark overlay for readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// 🔔 Notification Bell (Top Right)
                  Positioned(
                    top: 45,
                    right: 16,
                    child: NotificationBell(
                      hasNotification: true,
                      onTap: () {},
                    ),
                  ),

                  /// 👋 Welcome Text (Bottom Left)
                  Positioned(
                    left: 16,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.welcome_back,
                          style: FontManager.heading3(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(AppStrings.date_today,
                            style: FontManager.heading4(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // end of top stack
            //body part
            SingleChildScrollView(
              child: Column(
                children: [
                  // live mathes row
                  // live match cards (global)
                  // upcoming matches row
                  // upcoming matches cards (global)
                  // quick actions
                  // sponser card (global)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
