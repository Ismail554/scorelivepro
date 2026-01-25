import 'package:scorelivepro/models/live_ws_model.dart';
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
