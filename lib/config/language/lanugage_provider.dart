import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageLanguageHelper {
  static final _storage = const FlutterSecureStorage();

  // Save language
  static Future setLanguage(String langCode) async {
    await _storage.write(key: 'selected_language', value: langCode);
  }

  // Get saved language
  static Future<String?> getLanguage() async {
    return await _storage.read(key: 'selected_language');
  }
}