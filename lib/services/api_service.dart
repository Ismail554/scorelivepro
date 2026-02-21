class ApiEndPoint {
  static String get _baseUrl => "https://api.scorelivepro.it";
  static String get baseUrl => "https://api.scorelivepro.it";

  static String lineups(int id) => "$_baseUrl/sports/fixtures/$id/lineups/";
  static String statistics(int id) =>
      "$_baseUrl/sports/fixtures/$id/statistics/";
  static String get up_fin_matches => "$_baseUrl/sports/fixtures/";
  static String get upcomingMatches => "$_baseUrl/sports/fixtures/?status=upcoming";
  static String get finishedMatches => "$_baseUrl/sports/fixtures/?status=finished";

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
  
  
  static String leagueDetails(int id) => "$_baseUrl/sports/leagues/$id/"; // Response: { "id": 512, "name": "", "country": { "name": "", "code": "", "flag": "" }, "logo": "", "season_year": 2024 }
  static String get leagueStandingDetails => "$_baseUrl/sports/standings/"; // body { "league": 311 } // Response: { "count": 378, "next": "https://api.scorelivepro.it/sports/standings/?page=2", "previous": null, "results": [ { "league": 318, "season": 2025, "data": [ [ { "all": { "win": 17, "draw": 3, "lose": 2, "goals": { "for": 55, "against": 15 }, "played": 22 }, "away": { "win": 8, "draw": 1, "lose": 2, "goals": { "for": 29, "against": 11 }, "played": 11 }, "form": "WWWWW", "home": { "win": 9, "draw": 2, "lose": 0, "goals": { "for": 26, "against": 4 }, "played": 11 }, "rank": 1, "team": { "id": 3402, "logo": "", "name": " " }, "group": "", "points": 54, "status": "", "update": "", "goalsDiff": 40, "description": "" }, { "all": { "win": 5, "draw": 7, "lose": 17, "goals": { "for": 23, "against": 42 }, "played": 29 }, "away": { "win": 3, "draw": 3, "lose": 9, "goals": { "for": 10, "against": 23 }, "played": 15 }, "form": "LDLWL", "home": { "win": 2, "draw": 4, "lose": 8, "goals": { "for": 13, "against": 19 }, "played": 14 }, "rank": 24, "team": { "id": 1351, "logo": "", "name": " " }, "group": "", "points": 22, "status": "", "update": "", "goalsDiff": -19, "description": "" } ] ], "updated_at": "" } ] }




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
  // =================== Notifications ===========
  static String getNotifications() => "$_baseUrl/notifications/inbox/";// response body: [ { "id": 82149, "title": "📅 Premier League Schedule", "body": "There are 1 matches starting tomorrow in Premier League. Don't miss out!", "data": { "type": "SCHEDULE", "reason": "Following Premier League", "league_id": "322" }, "event_type": "MATCH_START", "created_at": "2026-02-17T08:00:13.960913Z", "time_ago": "3 days, 11 hours", "is_read": false }, { "id": 19290, "title": "📅 Premier League Schedule", "body": "There are 1 matches starting tomorrow in Premier League. Don't miss out!", "data": {}, "event_type": "MATCH_START", "created_at": "2026-01-28T21:31:35.331422Z", "time_ago": "3 weeks, 1 day", "is_read": false } ]
  static String markAllRead() => "$_baseUrl/notifications/mark-read/"; // use method POST
  static String deleteNotification(int id) => "$_baseUrl/notifications/remove/$id/"; // use method DELETE
}

