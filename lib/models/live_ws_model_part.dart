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
