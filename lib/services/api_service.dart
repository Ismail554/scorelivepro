import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndPoint {
  static String get _baseUrl =>
      dotenv.env['BASE_URL'] ?? "https://api.scorelivepro.it";
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? "https://api.scorelivepro.it";

  static String lineups(int id) => "$_baseUrl/sports/fixtures/$id/lineups/";
  static String statistics(int id) =>
      "$_baseUrl/sports/fixtures/$id/statistics/";
  static String get up_fin_matches => "$_baseUrl/sports/fixtures/";
  static String get upcomingMatches =>
      "$_baseUrl/sports/fixtures/?status=upcoming";
  static String get finishedMatches =>
      "$_baseUrl/sports/fixtures/?status=finished";

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
  static String getFixturesByLeague(int leagueId) =>
      "$_baseUrl/sports/fixtures/?league=$leagueId";
  static String getTeams(int id) =>
      "$_baseUrl/sports/teams/$id/"; // response: { "id": 311, "name": "Albirex Niigata", "logo": "https://media.api-sports.io/football/teams/311.png" }

  static String leagueDetails(int id) =>
      "$_baseUrl/sports/leagues/$id/"; // Response: { "id": 512, "name": "", "country": { "name": "", "code": "", "flag": "" }, "logo": "", "season_year": 2024 }
  static String leagueStandingDetails(int leagueId) =>
      "$_baseUrl/sports/standings/?league=$leagueId";
  static String fixturesHeadToHead(int fixtureID) =>
      "$_baseUrl/sports/fixtures/$fixtureID/h2h/";

  // ============= Notifications =============
  static String unreadNotificationsCount() =>
      "$_baseUrl/notifications/unread-count/"; // response body: { "unread_count": 0 }

  // ============= Teams & Leagues ==============
  static String getAllTeams({int? leagueId}) => leagueId != null
      ? "$_baseUrl/sports/teams/?leagues=$leagueId"
      : "$_baseUrl/sports/teams/"; // response body: { "count": 15214, "next": "...", "results": [ { "id": 18391, "name": "ADESG", "logo": "..." } ] }
  static String getAllLeagues() => "$_baseUrl/sports/leagues/";

  static String addToFavoriteLeaques() =>
      "$_baseUrl/auth/profile/favorites/leagues/"; // body: { "id": 0 } , use method POST for add and DELETE for remove
  static String addToFavoriteTeams() =>
      "$_baseUrl/auth/profile/favorites/teams/"; // body: { "id": 0 } , use method POST for add and DELETE for remove

  static String myFavoritesTeam() =>
      "$_baseUrl/auth/profile/favorites/teams/"; // [ { "id": 26605, "name": " Johnstone Burgh", "logo": "https://media.api-sports.io/football/teams/26605.png" } ]
  static String myFavoritesLeagues() =>
      "$_baseUrl/auth/profile/favorites/leagues/"; // [ { "id": 322, "name": "Premier League", "country": { "name": "Jamaica", "code": "JM", "flag": "https://media.api-sports.io/flags/jm.svg" }, "logo": "https://media.api-sports.io/football/leagues/322.png", "season_year": 2025 } ]
  static String forgotPassword() =>
      "$_baseUrl/auth/password-reset-request/"; // body: { "email": "user@example.com"}
  static String passwordResetVerifyOtp() =>
      "$_baseUrl/auth/password-reset-verify-otp/"; // body: { "email": "user@example.com", "otp": "string"}
  static String passwordResetConfirm() =>
      "$_baseUrl/auth/password-reset-confirm/"; // body: { "email": "user@example.com", "otp": "string", "password": "stringst", "confirm_password": "stringst"}

  static String getProfile() =>
      "$_baseUrl/auth/profile/"; // GET to retrieve, PATCH to edit body: { "first_name": "string", "last_name": "string", "profile_image": "string" }
  static String changePassword() =>
      "$_baseUrl/auth/profile/change-password/"; // POST body: { "old_password": "string", "new_password": "stringst", "confirm_password": "stringst" }

  // =================== Notifications ===========
  static String registerDevice() =>
      "$_baseUrl/notifications/devices/register/"; // POST body: { "registration_id": "string", "type": "ios", "active": true }
  static String getNotifications() =>
      "$_baseUrl/notifications/inbox/"; // response body: [ { "id": 82149, "title": "📅 Premier League Schedule", "body": "There are 1 matches starting tomorrow in Premier League. Don't miss out!", "data": { "type": "SCHEDULE", "reason": "Following Premier League", "league_id": "322" }, "event_type": "MATCH_START", "created_at": "2026-02-17T08:00:13.960913Z", "time_ago": "3 days, 11 hours", "is_read": false }, { "id": 19290, "title": "📅 Premier League Schedule", "body": "There are 1 matches starting tomorrow in Premier League. Don't miss out!", "data": {}, "event_type": "MATCH_START", "created_at": "2026-01-28T21:31:35.331422Z", "time_ago": "3 weeks, 1 day", "is_read": false } ]
  static String markAllRead() =>
      "$_baseUrl/notifications/mark-read/"; // use method POST
  static String deleteNotification(int id) =>
      "$_baseUrl/notifications/remove/$id/"; // use method DELETE

  static String deleteAccount() =>
      "$_baseUrl/auth/profile/delete/"; // use method DELETE

  static String googleLogin() =>
      "$_baseUrl/auth/google/"; //body: {"id_token": "eyJhbGciOiJSUzI1NiIsImtp... (long Google token string)"}
  static String appleLogin() =>
      "$_baseUrl/auth/apple/"; // body: {   "id_token": "eyJhbGci... (long Apple JWT)",   "user": {     "name": {       "firstName": "John",       "lastName": "Doe"     }   } }

      static String testToken(String token) => "$_baseUrl/notifications/test-push/?token=$token" ; // body: { "token": "fcm_token"}
}
