class ApiEndPoint {
  static String get _baseUrl => "https://api.scorelivepro.it";
  static String get baseUrl => "https://api.scorelivepro.it";

  static String lineups(int id) => "$_baseUrl/sports/fixtures/$id/lineups/";
  static String statistics(int id) =>
      "$_baseUrl/sports/fixtures/$id/statistics/";
  static String get up_fin_matches => "$_baseUrl/sports/fixtures/";

  // ============= Auth ================
  static String get login =>
      "$_baseUrl/auth/login/"; // body: {  "email": "string", "password": "string"}
  static String get register =>
      "$_baseUrl/auth/register/"; //body: {"email": "user@example.com", "first_name": "string", "last_name": "string", "password": "stringst", "confirm_password": "stringst"}
  static String get refreshToken =>
      "$_baseUrl/auth/token/refresh/"; // body and response both are same: {"refresh": "string"}
  static String get otpVerify =>
      "$_baseUrl/auth/verify-email/"; // body: {"email": "user@example.com", "otp": "string"}
  static String get resendOTP =>
      "$_baseUrl/auth/resend-activation-code/"; // body: {"email": "user@example.com"}, response: {"message": ""}
  static String get googleLogin =>
      "$_baseUrl/auth/google/"; // bodyt:{ "access_token": "string", "code": "string", "id_token": "string" }

  // ============= Leagues =============
  static String getFixtures(int id) => "$_baseUrl/sports/fixtures/$id/";
  static String getTeams(int id) =>
      "$_baseUrl/sports/teams/$id/"; // response: { "id": 311, "name": "Albirex Niigata", "logo": "https://media.api-sports.io/football/teams/311.png" }

  // ============= Notifications =============
  static String unreadNotificationsCount() =>
      "$_baseUrl/notifications/unread-count/"; // response body: { "unread_count": 0 }

  // ============= Teams & Leagues ==============
  static String getAllTeams() =>
      "$_baseUrl/sports/teams/"; // response body: { "count": 15214, "next": "https://api.scorelivepro.it/sports/teams/?page=2", "previous": null, "results": [ { "id": 18391, "name": "ADESG", "logo": "https://media.api-sports.io/football/teams/18391.png" } ] }
  static String getAllLeagues() => "$_baseUrl/sports/leagues/"; 

  static String addToFavoriteLeaques() =>
      "$_baseUrl/auth/profile/favorites/leagues/"; // body: { "id": 0 } , use method POST for add and DELETE for remove
  static String addToFavoriteTeams() =>
      "$_baseUrl/auth/profile/favorites/teams/"; // body: { "id": 0 } , use method POST for add and DELETE for remove





 static String myFavoritesTeam() => "$_baseUrl/auth/profile/favorites/teams/"; // [ { "id": 26605, "name": " Johnstone Burgh", "logo": "https://media.api-sports.io/football/teams/26605.png" } ]
 static String myFavoritesLeagues() => "$_baseUrl/auth/profile/favorites/leagues/"; // [ { "id": 322, "name": "Premier League", "country": { "name": "Jamaica", "code": "JM", "flag": "https://media.api-sports.io/flags/jm.svg" }, "logo": "https://media.api-sports.io/football/leagues/322.png", "season_year": 2025 } ]
  static String forgotPassword() => "$_baseUrl/auth/resend-activation-code/"; // body: { "email": "user@example.com"}
}
