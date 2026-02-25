// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcome_back => 'Bon retour';

  @override
  String get liveMatches => 'Matchs en direct';

  @override
  String get noLiveMatches => 'Aucun match en direct pour le moment';

  @override
  String get upcomingMatches => 'Matchs à venir';

  @override
  String get noUpcomingMatches => 'Aucun match à venir';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get myFavorites => 'Mes favoris';

  @override
  String get latestNews => 'Dernières nouvelles';

  @override
  String get unknownLeague => 'Ligue inconnue';

  @override
  String get home => 'Domicile';

  @override
  String get away => 'Extérieur';

  @override
  String get upcoming => 'À venir';

  @override
  String get language => 'Langue';
}
