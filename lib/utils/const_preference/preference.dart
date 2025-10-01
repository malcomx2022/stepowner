import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setString(String key, String value) async => await _preferences.setString(key, value);

  static String getString(String key) => _preferences.getString(key) ?? '';

  static Future setInt(String key, int value) async => await _preferences.setInt(key, value);

  static int getInt(String key) => _preferences.getInt(key) ?? 0;

  static Future setBoolean(String key, bool value) async => await _preferences.setBool(key, value);

  static bool getBoolean(String key) => _preferences.getBool(key) ?? false;

  static void clearPref() {
    _preferences.clear();
  }

  static void removeKey(String key) {
    _preferences.remove(key);
  }
}
