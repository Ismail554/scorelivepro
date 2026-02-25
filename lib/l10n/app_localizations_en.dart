// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_back => 'Welcome Back';

  @override
  String get liveMatches => 'Live Matches';

  @override
  String get noLiveMatches => 'No live matches at the moment';

  @override
  String get upcomingMatches => 'Upcoming Matches';

  @override
  String get noUpcomingMatches => 'No upcoming matches';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get latestNews => 'Latest News';

  @override
  String get unknownLeague => 'Unknown League';

  @override
  String get home => 'Home';

  @override
  String get away => 'Away';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get language => 'Language';
}
