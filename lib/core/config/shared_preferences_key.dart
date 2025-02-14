import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPreferenceKey{
  static const KEY_ACCESS_TOKEN = "KEY_ACCESS_TOKEN";
  static const KEY_REFRESH_TOKEN = "KEY_REFRESH_TOKEN";
  static const KEY_TOKEN_ID = "KEY_TOKEN_ID";
  static const KEY_LANGUAGE_CODE = "KEY_LANGUAGE_CODE";

  static Future<void> clearAll() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    const prefs = FlutterSecureStorage();
    await prefs.deleteAll();
  }
}