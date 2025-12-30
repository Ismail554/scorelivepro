/// Team Standings Data Model
/// Contains all the data needed for displaying team standings information
class TeamStandingsData {
  final String teamName;
  final int rank;
  final int points;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;

  const TeamStandingsData({
    required this.teamName,
    required this.rank,
    required this.points,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
  });
}

