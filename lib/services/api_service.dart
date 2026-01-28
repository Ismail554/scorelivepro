class ApiEndPoint {
  static String get _baseUrl => "https://api.scorelivepro.it";
  static String get baseUrl => "https://api.scorelivepro.it";

  static String lineups(int id) => "$_baseUrl/sports/fixtures/$id/lineups/";
  static String statistics(int id) =>
      "$_baseUrl/sports/fixtures/$id/statistics/";
  static String get up_fin_matches => "$_baseUrl/sports/fixtures/";
  static String get leagues => "$_baseUrl/sports/leagues/";

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

  // ============= Leagues =============
  static String getFixtures(int id) => "$_baseUrl/sports/fixtures/$id/";
  static String getTeams(int id) =>
      "$_baseUrl/sports/teams/$id/"; // response: { "id": 311, "name": "Albirex Niigata", "logo": "https://media.api-sports.io/football/teams/311.png" }

  // ============= Notifications =============
  static String unreadNotificationsCount() =>
      "$_baseUrl/notifications/unread-count/"; // response body: { "unread_count": 0 }
}
