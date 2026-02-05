class LiveScoreModel {
  String? type;
  List<Data>? data;

  LiveScoreModel({this.type, this.data});

  LiveScoreModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
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
    venue = json['venue'] != null ? new Venue.fromJson(json['venue']) : null;
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
    season =
        json['season'] != null ? new Season.fromJson(json['season']) : null;
    homeTeam = json['home_team'] != null
        ? new HomeTeam.fromJson(json['home_team'])
        : null;
    awayTeam = json['away_team'] != null
        ? new HomeTeam.fromJson(json['away_team'])
        : null;
    goals = json['goals'] != null ? new Goals.fromJson(json['goals']) : null;
    score = json['score'] != null ? new Score.fromJson(json['score']) : null;
    periods =
        json['periods'] != null ? new Periods.fromJson(json['periods']) : null;
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    if (json['lineups'] != null) {
      lineups = <Lineup>[];
      json['lineups'].forEach((v) {
        lineups!.add(new Lineup.fromJson(v));
      });
    }
    if (json['statistics'] != null) {
      statistics = <Statistic>[];
      json['statistics'].forEach((v) {
        statistics!.add(new Statistic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['timestamp'] = this.timestamp;
    data['timezone'] = this.timezone;
    data['referee'] = this.referee;
    data['round'] = this.round;
    data['status_long'] = this.statusLong;
    data['status_short'] = this.statusShort;
    data['elapsed'] = this.elapsed;
    if (this.venue != null) {
      data['venue'] = this.venue!.toJson();
    }
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.season != null) {
      data['season'] = this.season!.toJson();
    }
    if (this.homeTeam != null) {
      data['home_team'] = this.homeTeam!.toJson();
    }
    if (this.awayTeam != null) {
      data['away_team'] = this.awayTeam!.toJson();
    }
    if (this.goals != null) {
      data['goals'] = this.goals!.toJson();
    }
    if (this.score != null) {
      data['score'] = this.score!.toJson();
    }
    if (this.periods != null) {
      data['periods'] = this.periods!.toJson();
    }
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    if (this.lineups != null) {
      data['lineups'] = this.lineups!.map((v) => v.toJson()).toList();
    }
    if (this.statistics != null) {
      data['statistics'] = this.statistics!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city'] = this.city;
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
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    logo = json['logo'];
    seasonYear = json['season_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['logo'] = this.logo;
    data['season_year'] = this.seasonYear;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['flag'] = this.flag;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['away'] = this.away;
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
        json['halftime'] != null ? new Goals.fromJson(json['halftime']) : null;
    fulltime = json['fulltime'] != null
        ? new Fulltime.fromJson(json['fulltime'])
        : null;
    extratime = json['extratime'] != null
        ? new Fulltime.fromJson(json['extratime'])
        : null;
    penalty =
        json['penalty'] != null ? new Fulltime.fromJson(json['penalty']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.halftime != null) {
      data['halftime'] = this.halftime!.toJson();
    }
    if (this.fulltime != null) {
      data['fulltime'] = this.fulltime!.toJson();
    }
    if (this.extratime != null) {
      data['extratime'] = this.extratime!.toJson();
    }
    if (this.penalty != null) {
      data['penalty'] = this.penalty!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['away'] = this.away;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['second'] = this.second;
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
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
    team = json['team'] != null ? new HomeTeam.fromJson(json['team']) : null;
    player =
        json['player'] != null ? new Player.fromJson(json['player']) : null;
    assist =
        json['assist'] != null ? new Player.fromJson(json['assist']) : null;
    type = json['type'];
    detail = json['detail'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.time != null) {
      data['time'] = this.time!.toJson();
    }
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    if (this.player != null) {
      data['player'] = this.player!.toJson();
    }
    if (this.assist != null) {
      data['assist'] = this.assist!.toJson();
    }
    data['type'] = this.type;
    data['detail'] = this.detail;
    data['comments'] = this.comments;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['elapsed'] = this.elapsed;
    data['extra'] = this.extra;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['number'] = this.number;
    data['pos'] = this.pos;
    data['grid'] = this.grid;
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
    team = json['team'] != null ? new HomeTeam.fromJson(json['team']) : null;
    formation = json['formation'];
    if (json['startXI'] != null) {
      startXI = <StartXI>[];
      json['startXI'].forEach((v) {
        startXI!.add(new StartXI.fromJson(v));
      });
    }
    if (json['substitutes'] != null) {
      substitutes = <Substitute>[];
      json['substitutes'].forEach((v) {
        substitutes!.add(new Substitute.fromJson(v));
      });
    }
    coach = json['coach'] != null ? new Coach.fromJson(json['coach']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    data['formation'] = this.formation;
    if (this.startXI != null) {
      data['startXI'] = this.startXI!.map((v) => v.toJson()).toList();
    }
    if (this.substitutes != null) {
      data['substitutes'] = this.substitutes!.map((v) => v.toJson()).toList();
    }
    if (this.coach != null) {
      data['coach'] = this.coach!.toJson();
    }
    return data;
  }
}

class StartXI {
  Player? player;

  StartXI({this.player});

  StartXI.fromJson(Map<String, dynamic> json) {
    player =
        json['player'] != null ? new Player.fromJson(json['player']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.player != null) {
      data['player'] = this.player!.toJson();
    }
    return data;
  }
}

class Substitute {
  Player? player;

  Substitute({this.player});

  Substitute.fromJson(Map<String, dynamic> json) {
    player =
        json['player'] != null ? new Player.fromJson(json['player']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.player != null) {
      data['player'] = this.player!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    return data;
  }
}

class Statistic {
  HomeTeam? team;
  List<StatisticItem>? statistics;

  Statistic({this.team, this.statistics});

  Statistic.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? new HomeTeam.fromJson(json['team']) : null;
    if (json['statistics'] != null) {
      statistics = <StatisticItem>[];
      json['statistics'].forEach((v) {
        statistics!.add(new StatisticItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    if (this.statistics != null) {
      data['statistics'] = this.statistics!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
