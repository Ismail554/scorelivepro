class LeagueModel {
  final int? id;
  final String? name;
  final Country? country;
  final String? logo;
  final int? seasonYear;

  LeagueModel({
    this.id,
    this.name,
    this.country,
    this.logo,
    this.seasonYear,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    return LeagueModel(
      id: json['id'],
      name: json['name'],
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      logo: json['logo'],
      seasonYear: json['season_year'],
    );
  }
}

class Country {
  final String? name;
  final String? code;
  final String? flag;

  Country({this.name, this.code, this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      flag: json['flag'],
    );
  }
}
