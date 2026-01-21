import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  // single secure storage instance
  static const _storage = FlutterSecureStorage();

  /// ✅ Save theme securely
  static Future<void> saveTheme(String theme) async {
    await _storage.write(key: "theme", value: theme);
  }

  /// ✅ Get saved theme securely
  static Future<String?> getTheme() async {
    return await _storage.read(key: "theme");
  }

  /// ✅ Optional: Clear theme if needed
  static Future<void> clearTheme() async {
    await _storage.delete(key: "theme");
  }
}

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  // Token keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Save access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Clear all tokens and user data
  static Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userTypeKey);
  }

  /// Clear access token only
  static Future<void> clearAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  /// Clear refresh token only
  static Future<void> clearRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // User type key
  static const String _userTypeKey = 'user_type';

  /// Save user type
  static Future<void> saveUserType(String userType) async {
    await _storage.write(key: _userTypeKey, value: userType);
  }

  /// Get user type
  static Future<String?> getUserType() async {
    return await _storage.read(key: _userTypeKey);
  }

  /// Clear user type
  static Future<void> clearUserType() async {
    await _storage.delete(key: _userTypeKey);
  }
}
