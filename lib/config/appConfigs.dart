

import 'package:shared_preferences/shared_preferences.dart';

class AppConfigs {
  final SharedPreferences _prefs;

  AppConfigs(this._prefs);

  static const _keySecondsAhead = 'seconds_before_send';
  static const _keyNumberOfPhrases = 'number_of_phrases';

  Future<void> setSecondsAhead(int value) async {
    await _prefs.setInt(_keySecondsAhead, value);
  }

  Future<void> setNumberOfPhrases(int value) async {
    await _prefs.setInt(_keyNumberOfPhrases, value);
  }

  int get getSecondsAhead => _prefs.getInt(_keySecondsAhead) ?? 100;

  int get getNumberOfPhrases => _prefs.getInt(_keyNumberOfPhrases) ?? 60;


}