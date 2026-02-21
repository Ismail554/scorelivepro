class StandingsModel {
  final int? rank;
  final int? points;
  final int? goalsDiff;
  final StandingsTeam? team;
  final StandingsStats? all;

  StandingsModel({
    this.rank,
    this.points,
    this.goalsDiff,
    this.team,
    this.all,
  });

  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    return StandingsModel(
      rank: json['rank'],
      points: json['points'],
      goalsDiff: json['goalsDiff'],
      team: json['team'] != null ? StandingsTeam.fromJson(json['team']) : null,
      all: json['all'] != null ? StandingsStats.fromJson(json['all']) : null,
    );
  }
}

class StandingsTeam {
  final int? id;
  final String? name;
  final String? logo;

  StandingsTeam({this.id, this.name, this.logo});

  factory StandingsTeam.fromJson(Map<String, dynamic> json) {
    return StandingsTeam(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}

class StandingsStats {
  final int? win;
  final int? draw;
  final int? lose;
  final int? played;
  final StandingsGoals? goals;

  StandingsStats({this.win, this.draw, this.lose, this.played, this.goals});

  factory StandingsStats.fromJson(Map<String, dynamic> json) {
    return StandingsStats(
      win: json['win'],
      draw: json['draw'],
      lose: json['lose'],
      played: json['played'],
      goals:
          json['goals'] != null ? StandingsGoals.fromJson(json['goals']) : null,
    );
  }
}

class StandingsGoals {
  final int? goalsFor; // json key is 'for'
  final int? goalsAgainst; // json key is 'against'

  StandingsGoals({this.goalsFor, this.goalsAgainst});

  factory StandingsGoals.fromJson(Map<String, dynamic> json) {
    return StandingsGoals(
      goalsFor: json['for'],
      goalsAgainst: json['against'],
    );
  }
}

class StandingsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<StandingsModel> results;

  StandingsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory StandingsResponse.fromJson(Map<String, dynamic> json) {
    List<StandingsModel> parsedResults = [];
    if (json['results'] != null) {
      for (var result in json['results']) {
        if (result['data'] != null &&
            result['data'] is List &&
            result['data'].isNotEmpty) {
          var firstGroup = result['data'][0];
          if (firstGroup is List) {
            for (var item in firstGroup) {
              parsedResults.add(StandingsModel.fromJson(item));
            }
          }
        }
      }
    }

    return StandingsResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: parsedResults,
    );
  }
}
