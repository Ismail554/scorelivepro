import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale('pt')
  ];

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @liveMatches.
  ///
  /// In en, this message translates to:
  /// **'Live Matches'**
  String get liveMatches;

  /// No description provided for @noLiveMatches.
  ///
  /// In en, this message translates to:
  /// **'No live matches at the moment'**
  String get noLiveMatches;

  /// No description provided for @upcomingMatches.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Matches'**
  String get upcomingMatches;

  /// No description provided for @noUpcomingMatches.
  ///
  /// In en, this message translates to:
  /// **'No upcoming matches'**
  String get noUpcomingMatches;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @latestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get latestNews;

  /// No description provided for @unknownLeague.
  ///
  /// In en, this message translates to:
  /// **'Unknown League'**
  String get unknownLeague;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @away.
  ///
  /// In en, this message translates to:
  /// **'Away'**
  String get away;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure about logout?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @viewAndEditProfile.
  ///
  /// In en, this message translates to:
  /// **'View and edit profile'**
  String get viewAndEditProfile;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Login / Sign Up'**
  String get loginSignUp;

  /// No description provided for @syncFavorites.
  ///
  /// In en, this message translates to:
  /// **'Sync favorites across devices'**
  String get syncFavorites;

  /// No description provided for @failedNotificationUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update notification settings'**
  String get failedNotificationUpdate;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @permanentlyDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get permanentlyDeleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone.'**
  String get deleteAccountConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @failedDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get failedDeleteAccount;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Score Live Pro'**
  String get appName;

  /// No description provided for @realScoreNews.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Football Scores & News'**
  String get realScoreNews;

  /// No description provided for @copywrite.
  ///
  /// In en, this message translates to:
  /// **'© 2025 ScoreLivePRO'**
  String get copywrite;

  /// No description provided for @infoDesc.
  ///
  /// In en, this message translates to:
  /// **'ScoreLivePRO is not meant for collecting PII or securing sensitive data. This app is designed for entertainment and informational purposes only.'**
  String get infoDesc;

  /// No description provided for @langChangeAlert.
  ///
  /// In en, this message translates to:
  /// **'Language changes will take effect after restarting the app.'**
  String get langChangeAlert;

  /// No description provided for @changed.
  ///
  /// In en, this message translates to:
  /// **'changed'**
  String get changed;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @viewAndManageInfo.
  ///
  /// In en, this message translates to:
  /// **'View and manage your personal information'**
  String get viewAndManageInfo;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @securityDetails.
  ///
  /// In en, this message translates to:
  /// **'Security Details'**
  String get securityDetails;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @newPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get newPasswordsDoNotMatch;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully!'**
  String get updatedSuccessfully;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **' Password changed.'**
  String get passwordChanged;

  /// No description provided for @failedUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password. Please check your current password.'**
  String get failedUpdatePassword;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @realTimeScores.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Scores'**
  String get realTimeScores;

  /// No description provided for @realTimeScoresDesc.
  ///
  /// In en, this message translates to:
  /// **'Get live updates from matches around the world'**
  String get realTimeScoresDesc;

  /// No description provided for @globalCoverage.
  ///
  /// In en, this message translates to:
  /// **'Global Coverage'**
  String get globalCoverage;

  /// No description provided for @globalCoverageDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow leagues and teams from all over the world'**
  String get globalCoverageDesc;

  /// No description provided for @personalizedFavorites.
  ///
  /// In en, this message translates to:
  /// **'Personalized Favorites'**
  String get personalizedFavorites;

  /// No description provided for @personalizedFavoritesDesc.
  ///
  /// In en, this message translates to:
  /// **'Save your favorite teams and get quick access'**
  String get personalizedFavoritesDesc;

  /// No description provided for @matchStatistics.
  ///
  /// In en, this message translates to:
  /// **'Match Statistics'**
  String get matchStatistics;

  /// No description provided for @matchStatisticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Detailed stats, line-ups, and match timelines'**
  String get matchStatisticsDesc;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'ScoreLivePRO is your ultimate companion for staying updated with football scores, news, and stats. Our mission is to provide football fans with the fastest and most accurate information.\n\nWhether you\'re following your favorite team or exploring new leagues, ScoreLivePRO offers a seamless experience.'**
  String get aboutDescription;

  /// No description provided for @technicalInformation.
  ///
  /// In en, this message translates to:
  /// **'Technical Information'**
  String get technicalInformation;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @contactAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact & Support'**
  String get contactAndSupport;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2024 ScoreLivePRO. All rights reserved.\nMade with ❤️ for football fans worldwide'**
  String get footerCopyright;

  /// No description provided for @versionNumber.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionNumber;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for the app.'**
  String get selectLanguage;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Scores'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Lightning Fast Notifications'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Personalized Favorites'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Get live updates from matches around the world instantly'**
  String get onboardingDescription1;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Never miss a goal, card, or important match event'**
  String get onboardingDescription2;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Follow your favorite teams and leagues to stay updated'**
  String get onboardingDescription3;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulations;

  /// No description provided for @yourAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully'**
  String get yourAccountCreated;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get goToLogin;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful!'**
  String get loginSuccessful;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @pleaseAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to terms'**
  String get pleaseAgreeToTerms;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccessfully;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @noFavoriteTeams.
  ///
  /// In en, this message translates to:
  /// **'No favorite teams added yet.'**
  String get noFavoriteTeams;

  /// No description provided for @noFavoriteLeagues.
  ///
  /// In en, this message translates to:
  /// **'No favorite leagues added yet.'**
  String get noFavoriteLeagues;

  /// No description provided for @favoriteTeams.
  ///
  /// In en, this message translates to:
  /// **'Favorite Teams'**
  String get favoriteTeams;

  /// No description provided for @favoriteLeagues.
  ///
  /// In en, this message translates to:
  /// **'Favorite Leagues'**
  String get favoriteLeagues;

  /// No description provided for @leagues.
  ///
  /// In en, this message translates to:
  /// **'Leagues'**
  String get leagues;

  /// No description provided for @noLeagues.
  ///
  /// In en, this message translates to:
  /// **'No leagues available'**
  String get noLeagues;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @standings.
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get standings;

  /// No description provided for @fixtures.
  ///
  /// In en, this message translates to:
  /// **'Fixtures'**
  String get fixtures;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @lineups.
  ///
  /// In en, this message translates to:
  /// **'Lineups'**
  String get lineups;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @noStatisticsData.
  ///
  /// In en, this message translates to:
  /// **'No statistics data found'**
  String get noStatisticsData;

  /// No description provided for @upcomingMatchLineups.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Match Lineups'**
  String get upcomingMatchLineups;

  /// No description provided for @noLineupData.
  ///
  /// In en, this message translates to:
  /// **'No lineup data available'**
  String get noLineupData;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @browseTeams.
  ///
  /// In en, this message translates to:
  /// **'Browse Teams'**
  String get browseTeams;

  /// No description provided for @noTeams.
  ///
  /// In en, this message translates to:
  /// **'No teams available'**
  String get noTeams;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @noNews.
  ///
  /// In en, this message translates to:
  /// **'No news available'**
  String get noNews;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @syncYourFavorites.
  ///
  /// In en, this message translates to:
  /// **'Sync Your Favorites'**
  String get syncYourFavorites;

  /// No description provided for @syncFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Login to sync your favorites across all devices'**
  String get syncFavoritesDescription;

  /// No description provided for @loginToSync.
  ///
  /// In en, this message translates to:
  /// **'Login to Sync'**
  String get loginToSync;

  /// No description provided for @manageFavorites.
  ///
  /// In en, this message translates to:
  /// **'Manage your favorite teams and leagues'**
  String get manageFavorites;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @unreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notifications'**
  String unreadNotifications(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
