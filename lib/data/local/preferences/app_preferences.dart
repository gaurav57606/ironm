import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyThemeMode = 'theme_mode';
  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_keyThemeMode, mode);
  }

  String get themeMode => _prefs.getString(_keyThemeMode) ?? 'system';
}
