// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome_back => 'Bienvenido de nuevo';

  @override
  String get liveMatches => 'Partidos en vivo';

  @override
  String get noLiveMatches => 'No hay partidos en vivo en este momento';

  @override
  String get upcomingMatches => 'Próximos partidos';

  @override
  String get noUpcomingMatches => 'No hay próximos partidos';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get myFavorites => 'Mis favoritos';

  @override
  String get latestNews => 'Últimas noticias';

  @override
  String get unknownLeague => 'Liga desconocida';

  @override
  String get home => 'Local';

  @override
  String get away => 'Visitante';

  @override
  String get upcoming => 'Próximo';

  @override
  String get language => 'Idioma';
}
