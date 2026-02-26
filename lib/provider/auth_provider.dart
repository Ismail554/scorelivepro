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

  Future<String?> login(String email, String password) async {
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
          return error.toString();
        },
        (data) async {
          try {
            await _handleAuthSuccess(data);
            return null; // Return null on success
          } catch (e) {
            print("Parsing error: $e");
            _isLoading = false;
            notifyListeners();
            return "Cannot parse response";
          }
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "An unexpected error occurred.";
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

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.forgotPassword(),
        methods: Methods.post,
        body: {"email": email},
        skipAuth: true,
      );

      return result.fold(
        (error) {
          print("Forgot Password Error: $error");
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) {
          print("Forgot Password Success: $data");
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      print("Forgot Password Exception: $e");
      _isLoading = false;
      notifyListeners();
      return false;
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

  Future<bool> verifyPasswordResetOtp(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.passwordResetVerifyOtp(),
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

  Future<bool> passwordResetConfirm(
      String email, String otp, String password, String confirmPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.passwordResetConfirm(),
        methods: Methods.post,
        body: {
          "email": email,
          "otp": otp,
          "password": password,
          "confirm_password": confirmPassword,
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

      return result.fold(
        (l) {
          print("Resend OTP Error: $l");
          return false;
        },
        (r) {
          print("Resend OTP Success: $r");
          return true;
        },
      );
    } catch (e) {
      print("Resend OTP Exception: $e");
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

      // Fetch the full profile after a successful login to get the latest profile image etc.
      fetchUserProfile();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.getProfile(),
        methods: Methods.get,
      );

      result.fold(
        (error) {
          print("Error fetching profile: $error");
        },
        (data) async {
          _user = User.fromJson(data);
          await SecureStorageHelper.saveUser(jsonEncode(_user!.toJson()));
          notifyListeners();
        },
      );
    } catch (e) {
      print("Exception fetching profile: $e");
    }
  }

  Future<bool> updateProfile(
      String firstName, String lastName, String? profileImagePath) async {
    _isLoading = true;
    notifyListeners();

    try {
      final body = {
        "first_name": firstName,
        "last_name": lastName,
      };

      Either<String, dynamic> result;

      // Use multipart request if an image is provided
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        result = await DioManager.multipartRequest(
          url: ApiEndPoint.getProfile(),
          method: Methods.patch,
          fields: body,
          filePath: profileImagePath,
          fileFieldName: 'profile_image',
        );
      } else {
        // Otherwise use standard JSON request
        result = await DioManager.apiRequest(
          url: ApiEndPoint.getProfile(),
          methods: Methods.patch,
          body: body,
        );
      }

      return result.fold(
        (error) {
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) async {
          await fetchUserProfile(); // Refresh profile data
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.changePassword(),
        methods: Methods.post,
        body: {
          "old_password": oldPassword,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        },
      );

      return result.fold(
        (error) {
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) {
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _googleAuthService.signOut(); // Sign out from Google too
    await DioManager.logout();
    await SecureStorageHelper.clearUser();
    _user = null;
    notifyListeners();
  }

  Future<bool> deleteAccount() async {
    _isLoading = true;
    notifyListeners();

    try {
      // DioManager handles the access token automatically via Interceptors
      final result = await DioManager.apiRequest(
        url: ApiEndPoint.deleteAccount(),
        methods: Methods.delete,
        successCode: 200,
        altCodes: [204, 202, 201], // DELETE requests often return 204
      );

      return result.fold(
        (error) {
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) async {
          _isLoading = false;
          notifyListeners();
          await logout();
          return true;
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
