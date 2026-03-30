import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class AppleAuthService {
  Future<Map<String, dynamic>?> signInAndSync() async {
    const String reset = '\x1B[0m';
    const String red = '\x1B[31m';
    const String green = '\x1B[32m';
    const String yellow = '\x1B[33m';
    const String blue = '\x1B[34m';

    try {
      debugPrint("${blue}AppleAuthService: Starting signInAndSync...$reset");

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? idToken = credential.identityToken;
      final String? firstName = credential.givenName;
      final String? lastName = credential.familyName;

      debugPrint(
          "${green}AppleAuthService: idToken obtained: ${idToken != null ? 'YES' : 'NO'}$reset");

      if (idToken != null) {
        return await _sendTokenToBackend(idToken, firstName, lastName);
      } else {
        debugPrint("${red}AppleAuthService Error: idToken is null.$reset");
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint("${red}AppleAuthService Exception: $e$reset");
      debugPrint("${red}Stack Trace: $stackTrace$reset");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _sendTokenToBackend(String idToken, String? firstName, String? lastName) async {
    const String reset = '\x1B[0m';
    const String red = '\x1B[31m';
    const String green = '\x1B[32m';
    const String yellow = '\x1B[33m';
    const String blue = '\x1B[34m';

    debugPrint("${blue}AppleAuthService: POST to ${ApiEndPoint.appleLogin()} via DioManager$reset");

    final Map<String, dynamic> body = {
      "id_token": idToken,
      if (firstName != null || lastName != null)
        "user": {
          "name": {
            if (firstName != null) "firstName": firstName,
            if (lastName != null) "lastName": lastName,
          }
        }
    };

    final result = await DioManager.apiRequest(
      url: ApiEndPoint.appleLogin(),
      methods: Methods.post,
      body: body,
      skipAuth: true,
    );

    return result.fold(
      (errorMessage) {
        debugPrint("$red AppleAuthService: ❌ BACKEND ERROR: $errorMessage$reset");
        return null;
      },
      (data) {
        debugPrint("$green AppleAuthService: ✅ BACKEND SUCCESS$reset");
        if (data is Map<String, dynamic>) {
          return data;
        }
        return null;
      },
    );
  }
}
