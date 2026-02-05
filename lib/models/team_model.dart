class TeamModel {
  final int id;
  final String? name;
  final String? logo;
  final bool? isFavorite; // If the API supports it later

  TeamModel({
    required this.id,
    this.name,
    this.logo,
    this.isFavorite,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? 0,
      name: json['name'],
      logo: json['logo'],
      isFavorite: json['is_favorite'],
    );
  }
}

class TeamResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<TeamModel> results;

  TeamResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((e) => TeamModel.fromJson(e)).toList()
          : [],
    );
  }
}
