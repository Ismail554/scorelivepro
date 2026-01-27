class ApiEndPoint {
  static String get _baseUrl => "https://api.scorelivepro.it";
  static String get baseUrl => "https://api.scorelivepro.it";

  static String get login => "$_baseUrl/api/v1/auth/login";
  static String lineups(int id) => "$_baseUrl/sports/fixtures/$id/lineups/";
  static String statistics(int id) =>
      "$_baseUrl/sports/fixtures/$id/statistics/";
  static String get up_fin_matches => "$_baseUrl/sports/fixtures/";
  static String get leagues => "$_baseUrl/sports/leagues/";
  static String getLeagues(int id) => "$_baseUrl/sports/leagues/$id/";
}
