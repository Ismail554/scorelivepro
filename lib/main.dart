import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:scorelivepro/app.dart';
import 'package:scorelivepro/config/language/lanugage_provider.dart';
import 'package:scorelivepro/firebase_options.dart';
import 'package:scorelivepro/provider/match_provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/provider/notification_provider.dart';
import 'package:scorelivepro/services/dio_service.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/team_provider.dart';
import 'package:scorelivepro/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseService().initNotifications();

  try {
    // Initialize EasyLocalization
    await EasyLocalization.ensureInitialized();
    // Initialize Dio Interceptors
    DioManager.init();

    // Get saved language from secure storage
    String? savedLanguage;
    try {
      savedLanguage = await SecureStorageLanguageHelper.getLanguage();
    } catch (e) {
      // If secure storage fails, use default
      debugPrint("Secure Storage fails");
      print(e);
      savedLanguage = null;
    }
    Locale startLocale;
    // Map saved language to correct locale matching translation files
    switch (savedLanguage) {
      case "English":
        startLocale = const Locale('en', 'US');
        break;
      case "Spanish":
        startLocale = const Locale(
          'sp',
          'ES',
        );
        break;
      case "French":
        startLocale = const Locale('fr', 'FR');
        break;
      case "German":
        startLocale = const Locale(
          'de',
          'GM',
        );
        break;
      case "Italian":
        startLocale = const Locale('it', 'IT');
        break;
      case "Portuguese":
        startLocale = const Locale(
          'pt',
          'PR',
        );
        break;
      default:
        startLocale = const Locale('en', 'US');
    }
    runApp(
      EasyLocalization(
        // Supported locales matching translation files in assets/translations/
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('sp', 'ES'), // Spanish
          Locale('fr', 'FR'), // French
          Locale('de', 'GM'), // German
          Locale('it', 'IT'), // Italian
          Locale('pt', 'PR'), // Portuguese
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        startLocale: startLocale,
        useOnlyLangCode:
            false, // Use full locale (en-US) not just language code
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MatchProvider()),
            ChangeNotifierProvider(create: (_) => TeamProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: const ScoreLivePro(),
        ),
      ),
    );
  } catch (e, stackTrace) {
    // Log the error for debugging
    debugPrint('EasyLocalization initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    // Fallback if EasyLocalization fails - run app without localization
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Score Live Pro",
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
