import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scorelivepro/app.dart';
import 'package:scorelivepro/firebase_options.dart';
import 'package:scorelivepro/provider/language_provider.dart';
import 'package:scorelivepro/provider/match_provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/provider/notification_provider.dart';
import 'package:scorelivepro/provider/connectivity_provider.dart';
import 'package:scorelivepro/services/dio_service.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/team_provider.dart';
import 'package:scorelivepro/services/firebase_service.dart';
import 'package:scorelivepro/services/att_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    // Lock the orientation to portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Request ATT permission on iOS BEFORE initializing ads.
    // Ensures Apple's consent dialog appears first. No-op on Android.
    await ATTService().requestTrackingPermission();
    // Initialize the Mobile Ads SDK.
    await MobileAds.instance.initialize();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseService().initNotifications();
    DioManager.init();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => MatchProvider()),
          ChangeNotifierProvider(create: (_) => TeamProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ],
        child: const ScoreLivePro(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    // Fallback if EasyLocalization fails - run app without localization
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Score Live PRO",
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Initialization error. Please restart the app.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${e.toString()}',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
