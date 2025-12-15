import 'package:scorelivepro/widget/home/match_card.dart';

/// Fake / dummy data for the Matches screen.
///
/// This keeps sample content out of the UI widgets so you can
/// later swap in real API data without touching the layout.
class LiveMatchFakeModel {
  final String leagueName;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String timeInfo;
  final MatchStatus status;

  const LiveMatchFakeModel({
    required this.leagueName,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.timeInfo,
    required this.status,
  });
}

/// Fake matches currently live / in-progress.
const List<LiveMatchFakeModel> kLiveMatchesFake = [
  LiveMatchFakeModel(
    leagueName: 'Premier League',
    homeTeam: 'Manchester City',
    awayTeam: 'Arsenal',
    homeScore: 2,
    awayScore: 2,
    timeInfo: "78'",
    status: MatchStatus.live,
  ),
  LiveMatchFakeModel(
    leagueName: 'La Liga',
    homeTeam: 'Real Madrid',
    awayTeam: 'Atletico Madrid',
    homeScore: 3,
    awayScore: 1,
    timeInfo: "82'",
    status: MatchStatus.live,
  ),
  LiveMatchFakeModel(
    leagueName: 'Serie A',
    homeTeam: 'Inter Milan',
    awayTeam: 'AC Milan',
    homeScore: 1,
    awayScore: 0,
    timeInfo: "45+1'",
    status: MatchStatus.halfTime,
  ),
];

/// Fake upcoming matches.
const List<LiveMatchFakeModel> kUpcomingMatchesFake = [
  LiveMatchFakeModel(
    leagueName: 'Bundesliga',
    homeTeam: 'Bayern Munich',
    awayTeam: 'Borussia Dortmund',
    timeInfo: 'Today, 18:30',
    status: MatchStatus.upcoming,
  ),
  LiveMatchFakeModel(
    leagueName: 'Ligue 1',
    homeTeam: 'PSG',
    awayTeam: 'Marseille',
    timeInfo: 'Today, 20:45',
    status: MatchStatus.upcoming,
  ),
  LiveMatchFakeModel(
    leagueName: 'Premier League',
    homeTeam: 'Chelsea',
    awayTeam: 'Tottenham',
    timeInfo: 'Tomorrow, 15:00',
    status: MatchStatus.upcoming,
  ),
];

/// Fake finished matches.
const List<LiveMatchFakeModel> kFinishedMatchesFake = [
  LiveMatchFakeModel(
    leagueName: 'Premier League',
    homeTeam: 'Liverpool',
    awayTeam: 'Manchester United',
    homeScore: 3,
    awayScore: 1,
    timeInfo: 'Yesterday, 17:00',
    status: MatchStatus.finished,
  ),
  LiveMatchFakeModel(
    leagueName: 'La Liga',
    homeTeam: 'Barcelona',
    awayTeam: 'Valencia',
    homeScore: 2,
    awayScore: 0,
    timeInfo: 'Yesterday, 19:30',
    status: MatchStatus.finished,
  ),
  LiveMatchFakeModel(
    leagueName: 'Serie A',
    homeTeam: 'Juventus',
    awayTeam: 'Napoli',
    homeScore: 1,
    awayScore: 1,
    timeInfo: 'Dec 30, 20:00',
    status: MatchStatus.finished,
  ),
];
