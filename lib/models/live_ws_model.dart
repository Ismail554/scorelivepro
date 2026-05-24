class LiveScoreModel {
  String? type;
  List<Data>? data;

  LiveScoreModel({this.type, this.data});

  LiveScoreModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        final matchData = Data.fromJson(v);
        
        final shortStatus = matchData.statusShort?.toUpperCase();
        
        // Ignore "INT" matches explicitly
        if (shortStatus == 'INT') return;

        // Ensure we show only live matches
        const liveStatuses = ['1H', '2H', 'HT', 'ET', 'BT', 'P', 'LIVE'];
        if (liveStatuses.contains(shortStatus)) {
          data!.add(matchData);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? date;
  int? timestamp;
  String? timezone;
  String? referee;
  String? round;
  String? statusLong;
  String? statusShort;
  int? elapsed;
  Venue? venue;
  League? league;
  Season? season;
  HomeTeam? homeTeam;
  HomeTeam? awayTeam;
  Goals? goals;
  Score? score;
  Periods? periods;
  List<Events>? events;
  List<Lineup>? lineups;
  List<Statistic>? statistics;

  Data(
      {this.id,
      this.date,
      this.timestamp,
      this.timezone,
      this.referee,
      this.round,
      this.statusLong,
      this.statusShort,
      this.elapsed,
      this.venue,
      this.league,
      this.season,
      this.homeTeam,
      this.awayTeam,
      this.goals,
      this.score,
      this.periods,
      this.events,
      this.lineups,
      this.statistics});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    timestamp = json['timestamp'];
    timezone = json['timezone'];
    referee = json['referee'];
    round = json['round'];
    statusLong = json['status_long'];
    statusShort = json['status_short'];
    elapsed = json['elapsed'];
    venue = json['venue'] != null ? Venue.fromJson(json['venue']) : null;
    league =
        json['league'] != null ? League.fromJson(json['league']) : null;
    season =
        json['season'] != null ? Season.fromJson(json['season']) : null;
    homeTeam = json['home_team'] != null
        ? HomeTeam.fromJson(json['home_team'])
        : null;
    awayTeam = json['away_team'] != null
        ? HomeTeam.fromJson(json['away_team'])
        : null;
    goals = json['goals'] != null ? Goals.fromJson(json['goals']) : null;
    score = json['score'] != null ? Score.fromJson(json['score']) : null;
    periods =
        json['periods'] != null ? Periods.fromJson(json['periods']) : null;
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(Events.fromJson(v));
      });
    }
    if (json['lineups'] != null) {
      lineups = <Lineup>[];
      json['lineups'].forEach((v) {
        lineups!.add(Lineup.fromJson(v));
      });
    }
    if (json['statistics'] != null) {
      statistics = <Statistic>[];
      json['statistics'].forEach((v) {
        statistics!.add(Statistic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['timestamp'] = timestamp;
    data['timezone'] = timezone;
    data['referee'] = referee;
    data['round'] = round;
    data['status_long'] = statusLong;
    data['status_short'] = statusShort;
    data['elapsed'] = elapsed;
    if (venue != null) {
      data['venue'] = venue!.toJson();
    }
    if (league != null) {
      data['league'] = league!.toJson();
    }
    if (season != null) {
      data['season'] = season!.toJson();
    }
    if (homeTeam != null) {
      data['home_team'] = homeTeam!.toJson();
    }
    if (awayTeam != null) {
      data['away_team'] = awayTeam!.toJson();
    }
    if (goals != null) {
      data['goals'] = goals!.toJson();
    }
    if (score != null) {
      data['score'] = score!.toJson();
    }
    if (periods != null) {
      data['periods'] = periods!.toJson();
    }
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    if (lineups != null) {
      data['lineups'] = lineups!.map((v) => v.toJson()).toList();
    }
    if (statistics != null) {
      data['statistics'] = statistics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Venue {
  int? id;
  String? name;
  String? city;

  Venue({this.id, this.name, this.city});

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['city'] = city;
    return data;
  }
}

class League {
  int? id;
  String? name;
  Country? country;
  String? logo;
  int? seasonYear;

  League({this.id, this.name, this.country, this.logo, this.seasonYear});

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    logo = json['logo'];
    seasonYear = json['season_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['logo'] = logo;
    data['season_year'] = seasonYear;
    return data;
  }
}

class Country {
  String? name;
  String? code;
  String? flag;

  Country({this.name, this.code, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['flag'] = flag;
    return data;
  }
}

class Season {
  int? year;

  Season({this.year});

  Season.fromJson(Map<String, dynamic> json) {
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    return data;
  }
}

class HomeTeam {
  int? id;
  String? name;
  String? logo;

  HomeTeam({this.id, this.name, this.logo});

  HomeTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    return data;
  }
}

class Goals {
  int? home;
  int? away;

  Goals({this.home, this.away});

  Goals.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['home'] = home;
    data['away'] = away;
    return data;
  }
}

class Score {
  Goals? halftime;
  Fulltime? fulltime;
  Fulltime? extratime;
  Fulltime? penalty;

  Score({this.halftime, this.fulltime, this.extratime, this.penalty});

  Score.fromJson(Map<String, dynamic> json) {
    halftime =
        json['halftime'] != null ? Goals.fromJson(json['halftime']) : null;
    fulltime = json['fulltime'] != null
        ? Fulltime.fromJson(json['fulltime'])
        : null;
    extratime = json['extratime'] != null
        ? Fulltime.fromJson(json['extratime'])
        : null;
    penalty =
        json['penalty'] != null ? Fulltime.fromJson(json['penalty']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (halftime != null) {
      data['halftime'] = halftime!.toJson();
    }
    if (fulltime != null) {
      data['fulltime'] = fulltime!.toJson();
    }
    if (extratime != null) {
      data['extratime'] = extratime!.toJson();
    }
    if (penalty != null) {
      data['penalty'] = penalty!.toJson();
    }
    return data;
  }
}

class Fulltime {
  int? home;
  int? away;

  Fulltime({this.home, this.away});

  Fulltime.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['home'] = home;
    data['away'] = away;
    return data;
  }
}

class Periods {
  int? first;
  int? second;

  Periods({this.first, this.second});

  Periods.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    second = json['second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first'] = first;
    data['second'] = second;
    return data;
  }
}

class Events {
  Time? time;
  HomeTeam? team;
  Player? player;
  Player? assist;
  String? type;
  String? detail;
  String? comments;

  Events(
      {this.time,
      this.team,
      this.player,
      this.assist,
      this.type,
      this.detail,
      this.comments});

  Events.fromJson(Map<String, dynamic> json) {
    time = json['time'] != null ? Time.fromJson(json['time']) : null;
    team = json['team'] != null ? HomeTeam.fromJson(json['team']) : null;
    player =
        json['player'] != null ? Player.fromJson(json['player']) : null;
    assist =
        json['assist'] != null ? Player.fromJson(json['assist']) : null;
    type = json['type'];
    detail = json['detail'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (time != null) {
      data['time'] = time!.toJson();
    }
    if (team != null) {
      data['team'] = team!.toJson();
    }
    if (player != null) {
      data['player'] = player!.toJson();
    }
    if (assist != null) {
      data['assist'] = assist!.toJson();
    }
    data['type'] = type;
    data['detail'] = detail;
    data['comments'] = comments;
    return data;
  }
}

class Time {
  int? elapsed;
  int? extra;

  Time({this.elapsed, this.extra});

  Time.fromJson(Map<String, dynamic> json) {
    elapsed = json['elapsed'];
    extra = json['extra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['elapsed'] = elapsed;
    data['extra'] = extra;
    return data;
  }
}

class Player {
  int? id;
  String? name;
  String? number;
  String? pos;
  String? grid;

  Player({this.id, this.name, this.number, this.pos, this.grid});

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // Handle number as String or Int
    if (json['number'] != null) {
      number = json['number'].toString();
    }
    pos = json['pos'];
    grid = json['grid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['number'] = number;
    data['pos'] = pos;
    data['grid'] = grid;
    return data;
  }
}

class Lineup {
  HomeTeam? team;
  String? formation;
  List<StartXI>? startXI;
  List<Substitute>? substitutes;
  Coach? coach;

  Lineup(
      {this.team, this.formation, this.startXI, this.substitutes, this.coach});

  Lineup.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? HomeTeam.fromJson(json['team']) : null;
    formation = json['formation'];
    if (json['startXI'] != null) {
      startXI = <StartXI>[];
      json['startXI'].forEach((v) {
        startXI!.add(StartXI.fromJson(v));
      });
    }
    if (json['substitutes'] != null) {
      substitutes = <Substitute>[];
      json['substitutes'].forEach((v) {
        substitutes!.add(Substitute.fromJson(v));
      });
    }
    coach = json['coach'] != null ? Coach.fromJson(json['coach']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (team != null) {
      data['team'] = team!.toJson();
    }
    data['formation'] = formation;
    if (startXI != null) {
      data['startXI'] = startXI!.map((v) => v.toJson()).toList();
    }
    if (substitutes != null) {
      data['substitutes'] = substitutes!.map((v) => v.toJson()).toList();
    }
    if (coach != null) {
      data['coach'] = coach!.toJson();
    }
    return data;
  }
}

class StartXI {
  Player? player;

  StartXI({this.player});

  StartXI.fromJson(Map<String, dynamic> json) {
    player =
        json['player'] != null ? Player.fromJson(json['player']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (player != null) {
      data['player'] = player!.toJson();
    }
    return data;
  }
}

class Substitute {
  Player? player;

  Substitute({this.player});

  Substitute.fromJson(Map<String, dynamic> json) {
    player =
        json['player'] != null ? Player.fromJson(json['player']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (player != null) {
      data['player'] = player!.toJson();
    }
    return data;
  }
}

class Coach {
  int? id;
  String? name;
  String? photo;

  Coach({this.id, this.name, this.photo});

  Coach.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    return data;
  }
}

class Statistic {
  HomeTeam? team;
  List<StatisticItem>? statistics;

  Statistic({this.team, this.statistics});

  Statistic.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? HomeTeam.fromJson(json['team']) : null;
    if (json['statistics'] != null) {
      statistics = <StatisticItem>[];
      json['statistics'].forEach((v) {
        statistics!.add(StatisticItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (team != null) {
      data['team'] = team!.toJson();
    }
    if (statistics != null) {
      data['statistics'] = statistics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatisticItem {
  String? type;
  dynamic value;

  StatisticItem({this.type, this.value});

  StatisticItem.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
