# Complete Guide: Flutter Localization using Provider & gen-l10n

This documentation walks you through the exact process we followed to add robust, dynamic localization to ScoreLivePro. You can follow these steps to implement multi-language support in any Flutter app!

## 1. Setup Dependencies
Add the necessary localization packages to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  provider: ^6.1.2   # For state management
  flutter_secure_storage: ^9.0.0  # Optional: For saving user language preference
```

## 2. Configure `l10n.yaml`
At the root of your project, create a file named `l10n.yaml`. This file tells the `gen-l10n` tool how to generate your localization code.

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

## 3. Create ARB (Application Resource Bundle) Files
Create a new directory `lib/l10n/` and add your language files (e.g., `app_en.arb`, `app_es.arb`).

**`lib/l10n/app_en.arb`** (English - Template file)
```json
{
  "@@locale": "en",
  "welcomeMessage": "Welcome Back",
  "unreadCount": "{count} unread notifications",
  "@unreadCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**`lib/l10n/app_es.arb`** (Spanish)
```json
{
  "@@locale": "es",
  "welcomeMessage": "Bienvenido de nuevo",
  "unreadCount": "{count} notificaciones sin leer"
}
```

Whenever you add or change keys, run this command in the terminal to generate the Dart code:
```bash
flutter gen-l10n
```

## 4. Define Your Language Manager
Create a helper class to manage supported locales and codes.

**`lib/core/language_manager.dart`**
```dart
import 'package:flutter/material.dart';

class LanguageManager {
  static const Locale english = Locale('en', 'US');
  static const Locale spanish = Locale('es', 'ES');

  static const List<Locale> supportedLocales = [english, spanish];
  
  static const String englishCode = 'en';
  static const String spanishCode = 'es';

  static Locale getLocaleByCode(String code) {
    if (code == 'es') return spanish;
    return english;
  }
}
```

## 5. Build the `LanguageProvider`
This provider is responsible for holding the current state of the app's language, notifying the UI when it changes, and optionally saving the selection to secure storage.

**`lib/provider/language_provider.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:scorelivepro/core/language_manager.dart';

class LanguageProvider extends ChangeNotifier {
  // Start with English by default
  Locale _currentLocale = LanguageManager.english;
  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Load priority language when App starts
  Future<void> _loadSavedLanguage() async {
    // Implement your logic to read from SharedPreferences or SecureStorage
    String? savedCode = "en"; // Example: get from storage
    _currentLocale = LanguageManager.getLocaleByCode(savedCode);
    notifyListeners();
  }

  // Called from the Language Selection Screen
  Future<void> changeLanguage(Locale newLocale) async {
    if (_currentLocale == newLocale) return; // Prevent unnecessary rebuilds

    _currentLocale = newLocale;
    notifyListeners(); // Tells MaterialApp to rebuild with new language

    // Always save the user's choice to storage
    // Example: await SecureStorage.saveLanguage(newLocale.languageCode);
  }
}
```

## 6. Wrap Your App in Providers
Inject your provider at the top level of your app in `main.dart` or `app.dart`.

**`lib/main.dart`**
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

## 7. Connect Localization to `MaterialApp`
Use `Consumer` to listen to the `LanguageProvider`. Pass the generated delegates and supported locales to `MaterialApp`.

**`lib/app.dart`**
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scorelivepro/l10n/app_localizations.dart'; // The generated file

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'My Game App',
          
          // Use the locale from our Provider!
          locale: languageProvider.currentLocale,
          
          // Required Localization setups
          localizationsDelegates: const [
            AppLocalizations.delegate, // Generated delegate
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales, // Auto-generated
          
          home: const HomeScreen(),
        );
      },
    );
  }
}
```

## 8. Use Translated Strings in Your UI
Replace any hardcoded string in your UI components with `AppLocalizations.of(context)`.

**Important:** Because `AppLocalizations.of(context)` accesses runtime state attached to the BuildContext, you cannot use the `const` keyword on widgets that display text!

```dart
// ❌ WRONG: Hardcoded
Text("Welcome Back")

// ❌ WRONG: Using 'const' with dynamic localization
const Text(AppLocalizations.of(context).welcomeMessage)

// ✅ CORRECT
Text(AppLocalizations.of(context).welcomeMessage)
```

Dealing with arguments/variables:
```dart
// Using the 'unreadCount' arg we setup in `app_en.arb`
Text(AppLocalizations.of(context).unreadCount(5)) 
// Output: "5 unread notifications"
```

## 9. Switch Languages in Settings
In your language selection screen, call the provider to apply the new locale.

```dart
ListTile(
  title: const Text("Español"),
  onTap: () {
    // 1. Get the provider without listening (listen: false) inside events/callbacks
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    
    // 2. Instruct the provider to change and rebuild the app
    provider.changeLanguage(LanguageManager.spanish);
  },
)
```

## Summary Checklist
1. Add `intl` and `flutter_localizations`
2. Configure `l10n.yaml`
3. Create `app_en.arb` and translation files
4. Run `flutter gen-l10n`
5. Create `LanguageProvider` with `ChangeNotifier`
6. Put `ChangeNotifierProvider` globally around `MyApp`
7. In `MaterialApp`, assign `locale: provider.currentLocale`
8. Call `AppLocalizations.of(context).key` anywhere in the app!
