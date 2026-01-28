import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';
import 'package:scorelivepro/models/auth_response_model.dart';
import 'package:scorelivepro/models/user_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  bool get isLoggedIn => _user != null;

  AuthProvider() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await SecureStorageHelper.getAccessToken();
    final userJson = await SecureStorageHelper.getUser();

    if (token != null && userJson != null) {
      try {
        _user = User.fromJson(jsonDecode(userJson));
        _isLoading = false; // Just to be safe, though init is syncish
        notifyListeners();
      } catch (e) {
        // If parsing fails, clear storage
        await logout();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.login,
        methods: Methods.post,
        body: {
          "email": email,
          "password": password,
          // "device_id": ... // Isolate/Intercept already handles X-Device-ID header if needed, or we can add it here implicitly if API expects body
        },
        skipAuth: true,
      );

      return result.fold(
        (error) {
          _isLoading = false;
          notifyListeners();
          return false; // Or rethrow / handle error display via callback
        },
        (data) async {
          try {
            final authResponse = AuthResponse.fromJson(data);

            if (authResponse.access != null) {
              await SecureStorageHelper.saveAccessToken(authResponse.access!);
            }
            if (authResponse.refresh != null) {
              await SecureStorageHelper.saveRefreshToken(authResponse.refresh!);
            }
            if (authResponse.user != null) {
              _user = authResponse.user;
              await SecureStorageHelper.saveUser(jsonEncode(_user!.toJson()));
            }

            _isLoading = false;
            notifyListeners();
            return true;
          } catch (e) {
            print("Parsing error: $e");
            _isLoading = false;
            notifyListeners();
            return false;
          }
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> register(String email, String firstName, String lastName,
      String password, String confirmPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.register,
        methods: Methods.post,
        body: {
          "email": email,
          "first_name": firstName,
          "last_name": lastName,
          "password": password,
          "confirm_password": confirmPassword,
        },
        skipAuth: true,
        successCode: 201,
      );

      return result.fold(
        (error) {
          _isLoading = false;
          notifyListeners();
          return null; // Failure
        },
        (data) {
          _isLoading = false;
          notifyListeners();
          // Extract message or use default
          return data['message'] as String? ?? "Registration successful";
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> verifyEmail(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.otpVerify,
        methods: Methods.post,
        body: {
          "email": email,
          "otp": otp,
        },
        skipAuth: true,
      );

      return result.fold((error) {
        _isLoading = false;
        notifyListeners();
        return false;
      }, (data) {
        _isLoading = false;
        notifyListeners();
        return true;
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendOtp(String email) async {
    try {
      // Ideally show some loading for resend too, but maybe just return result
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.resendOTP,
        methods: Methods.post,
        body: {"email": email},
        skipAuth: true,
      );

      return result.fold((l) => false, (r) => true);
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await DioManager
        .logout(); // Clears access token and calls SecureStorageHelper.clearAll
    await SecureStorageHelper
        .clearUser(); // Explicitly clear user if clearAll doesn't (Base clearAll might not know about new key)
    _user = null;
    notifyListeners();
  }
}
