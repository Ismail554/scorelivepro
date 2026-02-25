// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get welcome_back => 'Willkommen zurück';

  @override
  String get liveMatches => 'Live-Spiele';

  @override
  String get noLiveMatches => 'Im Moment keine Live-Spiele';

  @override
  String get upcomingMatches => 'Kommende Spiele';

  @override
  String get noUpcomingMatches => 'Keine kommenden Spiele';

  @override
  String get quickActions => 'Schnellzugriffe';

  @override
  String get myFavorites => 'Meine Favoriten';

  @override
  String get latestNews => 'Neueste Nachrichten';

  @override
  String get unknownLeague => 'Unbekannte Liga';

  @override
  String get home => 'Heim';

  @override
  String get away => 'Auswärts';

  @override
  String get upcoming => 'Kommend';

  @override
  String get language => 'Sprache';
}
