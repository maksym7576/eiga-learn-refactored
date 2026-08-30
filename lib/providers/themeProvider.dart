import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eiga/providers/packageProviders.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(_loadInitialMode(_prefs));

  static ThemeMode _loadInitialMode(SharedPreferences prefs) {
    final savedMode = prefs.getString(_key);
    if (savedMode == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == savedMode,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, mode.toString());
  }
}
