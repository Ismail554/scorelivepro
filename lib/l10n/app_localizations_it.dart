// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get welcome_back => 'Bentornato';

  @override
  String get liveMatches => 'Partite in diretta';

  @override
  String get noLiveMatches => 'Nessuna partita in diretta al momento';

  @override
  String get upcomingMatches => 'Prossime partite';

  @override
  String get noUpcomingMatches => 'Nessuna prossima partita';

  @override
  String get quickActions => 'Azioni rapide';

  @override
  String get myFavorites => 'I miei preferiti';

  @override
  String get latestNews => 'Ultime notizie';

  @override
  String get unknownLeague => 'Lega sconosciuta';

  @override
  String get home => 'Casa';

  @override
  String get away => 'Trasferta';

  @override
  String get upcoming => 'In arrivo';

  @override
  String get language => 'Lingua';
}
