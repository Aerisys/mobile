import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const String _hasSeenWelcomeKey = 'has_seen_welcome';

  bool get hasSeenWelcome => _prefs.getBool(_hasSeenWelcomeKey) ?? false;

  Future<void> setHasSeenWelcome(bool value) async {
    await _prefs.setBool(_hasSeenWelcomeKey, value);
  }
}
