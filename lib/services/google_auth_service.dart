import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class GoogleAuthService {
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  GoogleAuthService();

  Future<void> _ensureInitialized() async {
    // Initialize the singleton with configuration
    await _googleSignIn.initialize(
      serverClientId: "641571105178-n1cakg9mh25f2qmubq96o6che2gtfa2t.apps.googleusercontent.com",
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
      debugPrint("${yellow}GoogleAuthService: calling _googleSignIn.authenticate()...$reset");
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      debugPrint(
          "${green}GoogleAuthService: Signed in user: ${googleUser.email}$reset");

      // 3. Obtain idToken
      debugPrint("${yellow}GoogleAuthService: Obtaining authentication tokens...$reset");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      debugPrint(
          "${green}GoogleAuthService: idToken obtained: ${idToken != null ? 'YES (Length: ${idToken.length})' : 'NO'}$reset");

      if (idToken != null) {
        debugPrint("${blue}GoogleAuthService: Sending idToken to backend...$reset");
        return await _sendTokenToBackend(idToken);
      } else {
        debugPrint(
            "${red}GoogleAuthService Error: idToken is null. (Check configuration and client IDs)$reset");
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint("${red}GoogleAuthService Exception: $e$reset");
      debugPrint("${red}Stack Trace: $stackTrace$reset");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _sendTokenToBackend(String idToken) async {
    // ANSI Color Codes
    const String reset = '\x1B[0m';
    const String red = '\x1B[31m';
    const String green = '\x1B[32m';
    const String yellow = '\x1B[33m';
    const String blue = '\x1B[34m';

    debugPrint(
        "${blue}GoogleAuthService: POST to ${ApiEndPoint.googleLogin()} via DioManager$reset");
    debugPrint("$yellow------------------------------------------------$reset");
    debugPrint("$yellow GoogleAuthService: PREPARING PAYLOAD:$reset");
    debugPrint("$yellow id_token: ${idToken.substring(0, 10)}...$reset");
    debugPrint("$yellow------------------------------------------------$reset");

    final result = await DioManager.apiRequest(
      url: ApiEndPoint.googleLogin(),
      methods: Methods.post,
      body: {
        "id_token": idToken,
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
