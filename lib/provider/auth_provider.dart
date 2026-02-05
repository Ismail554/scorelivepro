import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';
import 'package:scorelivepro/models/auth_response_model.dart';
import 'package:scorelivepro/models/user_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';
// ✅ Import the new service
import 'package:scorelivepro/services/google_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  // Initialize the new Google Service
  final GoogleAuthService _googleAuthService = GoogleAuthService();

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
        _isLoading = false;
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
        },
        skipAuth: true,
      );

      return result.fold(
        (error) {
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) async {
          try {
            await _handleAuthSuccess(data);
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

  // 👇 UPDATED: The Real Google Login Implementation
  Future<bool> googleLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Get Code & Send to Backend
      final backendData = await _googleAuthService.signInAndSync();

      if (backendData == null) {
        _isLoading = false;
        notifyListeners();
        return false; // Failed or Cancelled
      }

      // 2. Parse Response (Reusing helper)
      await _handleAuthSuccess(backendData);

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Google Login Error: $e");
      return false;
    }
  }

  // Helper to reduce code duplication
  Future<void> _handleAuthSuccess(Map<String, dynamic> data) async {
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
  }

  Future<void> logout() async {
    await _googleAuthService.signOut(); // Sign out from Google too
    await DioManager.logout();
    await SecureStorageHelper.clearUser();
    _user = null;
    notifyListeners();
  }
}
