class H2HModel {
  int? team1;
  int? team2;
  int? team1Wins;
  int? team2Wins;
  int? draws;
  int? totalPlayed;
  List<H2HMatchHistory>? history;

  H2HModel({
    this.team1,
    this.team2,
    this.team1Wins,
    this.team2Wins,
    this.draws,
    this.totalPlayed,
    this.history,
  });

  H2HModel.fromJson(Map<String, dynamic> json) {
    team1 = json['team_1'];
    team2 = json['team_2'];
    team1Wins = json['team_1_wins'];
    team2Wins = json['team_2_wins'];
    draws = json['draws'];
    totalPlayed = json['total_played'];
    if (json['history'] != null) {
      history = <H2HMatchHistory>[];
      json['history'].forEach((v) {
        history!.add(H2HMatchHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['team_1'] = team1;
    data['team_2'] = team2;
    data['team_1_wins'] = team1Wins;
    data['team_2_wins'] = team2Wins;
    data['draws'] = draws;
    data['total_played'] = totalPlayed;
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class H2HMatchHistory {
  String? date;
  String? score;
  String? status;
  String? awayLogo;
  String? awayName;
  String? homeLogo;
  String? homeName;
  int? fixtureId;

  H2HMatchHistory({
    this.date,
    this.score,
    this.status,
    this.awayLogo,
    this.awayName,
    this.homeLogo,
    this.homeName,
    this.fixtureId,
  });

  H2HMatchHistory.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    score = json['score'];
    status = json['status'];
    awayLogo = json['away_logo'];
    awayName = json['away_name'];
    homeLogo = json['home_logo'];
    homeName = json['home_name'];
    fixtureId = json['fixture_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['score'] = score;
    data['status'] = status;
    data['away_logo'] = awayLogo;
    data['away_name'] = awayName;
    data['home_logo'] = homeLogo;
    data['home_name'] = homeName;
    data['fixture_id'] = fixtureId;
    return data;
  }
}
