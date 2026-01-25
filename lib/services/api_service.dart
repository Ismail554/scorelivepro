class ApiEndPoint {
  static String get _baseUrl => "https://api.scorelivepro.it";
  static String get baseUrl => "https://api.scorelivepro.it";

  static String get login => "$_baseUrl/api/v1/auth/login";
  static String lineups (int id) => "$_baseUrl/fixtures/$id/lineups/";
}
