import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_lib;
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class GoogleAuthService {
  // 🔴 YOUR WEB CLIENT ID
  final String _webClientId =
      "641571105178-d0529b3arcdoo6fd2istoinrdcbh3m9a.apps.googleusercontent.com";

  // Use the singleton instance
  google_lib.GoogleSignIn get _googleSignIn => google_lib.GoogleSignIn.instance;

  GoogleAuthService();

  Future<void> _ensureInitialized() async {
    // Initialize the singleton with configuration
    // This must be called before authentication
    await _googleSignIn.initialize(
      serverClientId: _webClientId,
    );
  }

  Future<Map<String, dynamic>?> signInAndSync() async {
    // ANSI Color Codes
    const String reset = '\x1B[0m';
    const String red = '\x1B[31m';
    const String green = '\x1B[32m';
    const String yellow = '\x1B[33m';
    const String blue = '\x1B[34m';

    try {
      debugPrint("${blue}GoogleAuthService: Starting signInAndSync...$reset");

      // 1. Ensure initialized
      debugPrint(
          "${yellow}GoogleAuthService: calling _ensureInitialized...$reset");
      await _ensureInitialized();
      debugPrint(
          "${green}GoogleAuthService: _ensureInitialized completed.$reset");

      // 2. Authenticate (triggers the sign-in flow)
      // Note: authenticate() returns a Future<GoogleSignInAccount> or throws
      debugPrint(
          "${yellow}GoogleAuthService: calling _googleSignIn.authenticate...$reset");
      final google_lib.GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
      debugPrint(
          "${green}GoogleAuthService: Authenticated user: ${googleUser.email} (id: ${googleUser.id})$reset");

      // 3. Get the Auth Code
      // google_sign_in ^7.0.0
      // We authorize against the server client ID (set in initialize) requesting specific scopes.
      debugPrint(
          "${yellow}GoogleAuthService: Requesting server auth code...$reset");
      final authResponse = await googleUser.authorizationClient
          .authorizeServer(['email', 'profile']);

      final String? authCode = authResponse?.serverAuthCode;
      debugPrint(
          "${green}GoogleAuthService: Server Auth Code obtained: ${authCode != null ? 'YES (Length: ${authCode.length})' : 'NO'}$reset");

      if (authCode != null) {
        debugPrint(
            "${blue}GoogleAuthService: Sending code to backend...$reset");
        return await _sendCodeToBackend(authCode);
      } else {
        debugPrint(
            "${red}GoogleAuthService Error: Auth Code is null. (Check Web Client ID and Console Config)$reset");
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint("${red}GoogleAuthService Exception: $e$reset");
      debugPrint("${red}Stack Trace: $stackTrace$reset");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _sendCodeToBackend(String authCode) async {
    // ANSI Color Codes
    const String reset = '\x1B[0m';
    const String red = '\x1B[31m';
    const String green = '\x1B[32m';
    const String yellow = '\x1B[33m';
    const String blue = '\x1B[34m';

    // Using DioManager for consistent logging and headers (including UUID if needed)
    debugPrint(
        "${blue}GoogleAuthService: POST to ${ApiEndPoint.googleLogin} via DioManager$reset");
    debugPrint("$yellow------------------------------------------------$reset");
    debugPrint("$yellow GoogleAuthService: PREPARING PAYLOAD:$reset");
    debugPrint("$yellow code: $authCode$reset");
    const String callbackUrl = "postmessage";
    debugPrint("$yellow callback_url: $callbackUrl$reset");
    debugPrint("$yellow------------------------------------------------$reset");

    final result = await DioManager.apiRequest(
      url: ApiEndPoint.googleLogin,
      methods: Methods.post,
      body: {
        "code": authCode,
        "callback_url": "postmessage",
      },
      skipAuth: true,
    );

    return result.fold(
      (errorMessage) {
        debugPrint("$red GoogleAuthService: ❌ BACKEND ERROR$reset");
        debugPrint(
            "$red GoogleAuthService: Error Message: $errorMessage$reset");
        return null;
      },
      (data) {
        debugPrint("$green GoogleAuthService: ✅ BACKEND SUCCESS$reset");
        debugPrint("$green GoogleAuthService: Response Data: $data$reset");
        if (data is Map<String, dynamic>) {
          return data;
        }
        return null;
      },
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
