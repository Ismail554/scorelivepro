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

class LeagueResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<LeagueModel> results;

  LeagueResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory LeagueResponse.fromJson(Map<String, dynamic> json) {
    return LeagueResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List)
              .map((e) => LeagueModel.fromJson(e))
              .toList()
          : [],
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
