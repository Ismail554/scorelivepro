// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get welcome_back => 'Bem-vindo de volta';

  @override
  String get liveMatches => 'Partidas ao vivo';

  @override
  String get noLiveMatches => 'Sem partidas ao vivo no momento';

  @override
  String get upcomingMatches => 'Próximas partidas';

  @override
  String get noUpcomingMatches => 'Nenhuma partida futura';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get myFavorites => 'Meus favoritos';

  @override
  String get latestNews => 'Últimas notícias';

  @override
  String get unknownLeague => 'Liga desconhecida';

  @override
  String get home => 'Casa';

  @override
  String get away => 'Visitante';

  @override
  String get upcoming => 'Próximos';

  @override
  String get language => 'Idioma';
}
