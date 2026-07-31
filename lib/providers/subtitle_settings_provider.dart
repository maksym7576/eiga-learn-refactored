import 'package:eiga/backend/data/models/subtitleSettings.dart';
import 'package:eiga/providers/packageProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubtitleSettingsNotifier extends AutoDisposeAsyncNotifier<SubtitleSettingsState> {
  static const _keyPortraitPreset = 'sub_preset_port_v7';
  static const _keyFSPreset = 'sub_preset_fs_v7';
  static const _keyFSBgEnabled = 'sub_fs_bg_en_v7';
  static const _keyFSBgColor = 'sub_fs_bg_col_v7';
  static const _keyFSGroupOffset = 'sub_fs_group_off_v7';

  static const _keyFontOrig = 'sub_fnt_orig_v7';
  static const _keyFontAdd = 'sub_fnt_add_v7';
  static const _keyFontTrans = 'sub_fnt_trans_v7';
  static const _keyGlobalScale = 'sub_glob_scale_v7';

  static const _keyBoldOrig = 'sub_bold_orig_v7';
  static const _keyBoldAdd = 'sub_bold_add_v7';
  static const _keyBoldTrans = 'sub_bold_trans_v7';

  static const _keyItalicOrig = 'sub_ital_orig_v7';
  static const _keyItalicAdd = 'sub_ital_add_v7';
  static const _keyItalicTrans = 'sub_ital_trans_v7';

  @override
  Future<SubtitleSettingsState> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);

    SubtitleConfig buildConfig(bool isFS) {
      final prefix = isFS ? 'fs' : 'port';
      final presetName = prefs.getString(isFS ? _keyFSPreset : _keyPortraitPreset) ?? 'Original';

      return SubtitleConfig(
        presetName: presetName,
        backgroundEnabled: isFS ? (prefs.getBool(_keyFSBgEnabled) ?? false) : false,
        backgroundColor: prefs.getInt(_keyFSBgColor) ?? 0x80000000,
        fontSizeOriginal: prefs.getDouble('${_keyFontOrig}_$prefix') ?? (isFS ? 28.0 : 18.0),
        fontSizeAdditional: prefs.getDouble('${_keyFontAdd}_$prefix') ?? (isFS ? 16.0 : 10.0),
        fontSizeTranslation: prefs.getDouble('${_keyFontTrans}_$prefix') ?? (isFS ? 20.0 : 14.0),
        isBoldOriginal: prefs.getBool('${_keyBoldOrig}_$prefix') ?? true,
        isBoldAdditional: prefs.getBool('${_keyBoldAdd}_$prefix') ?? false,
        isBoldTranslation: prefs.getBool('${_keyBoldTrans}_$prefix') ?? false,
        isItalicOriginal: prefs.getBool('${_keyItalicOrig}_$prefix') ?? false,
        isItalicAdditional: prefs.getBool('${_keyItalicAdd}_$prefix') ?? false,
        isItalicTranslation: prefs.getBool('${_keyItalicTrans}_$prefix') ?? true,
        groupOffset: isFS ? (prefs.getDouble(_keyFSGroupOffset) ?? 0.1) : 0.0,
        globalScale: prefs.getDouble('${_keyGlobalScale}_$prefix') ?? 1.0,
      );
    }

    return SubtitleSettingsState(
      fullScreen: buildConfig(true),
      portrait: buildConfig(false),
    );
  }

  Future<void> updatePreset(bool isFullScreen, String name) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value!;
    final key = isFullScreen ? _keyFSPreset : _keyPortraitPreset;
    await prefs.setString(key, name);

    // Default values for presets (can be expanded later)
    double fsOrig = 28, fsAdd = 16, fsTrans = 20;
    double portOrig = 18, portAdd = 10, portTrans = 14;

    if (name == 'Crunchyroll') {
      // Just some variation for testing
      fsOrig = 32; portOrig = 20;
    }

    final prefix = isFullScreen ? 'fs' : 'port';
    if (isFullScreen) {
      await prefs.setDouble('${_keyFontOrig}_$prefix', fsOrig);
      await prefs.setDouble('${_keyFontAdd}_$prefix', fsAdd);
      await prefs.setDouble('${_keyFontTrans}_$prefix', fsTrans);
    } else {
      await prefs.setDouble('${_keyFontOrig}_$prefix', portOrig);
      await prefs.setDouble('${_keyFontAdd}_$prefix', portAdd);
      await prefs.setDouble('${_keyFontTrans}_$prefix', portTrans);
    }

    final newConfig = (isFullScreen ? current.fullScreen : current.portrait).copyWith(
      presetName: name,
      fontSizeOriginal: isFullScreen ? fsOrig : portOrig,
      fontSizeAdditional: isFullScreen ? fsAdd : portAdd,
      fontSizeTranslation: isFullScreen ? fsTrans : portTrans,
    );

    state = AsyncData(isFullScreen
        ? current.copyWith(fullScreen: newConfig)
        : current.copyWith(portrait: newConfig));
  }

  Future<void> updateStyleToggle(bool isFullScreen, SubtitleElementType type, {bool? bold, bool? italic}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value!;
    final prefix = isFullScreen ? 'fs' : 'port';

    SubtitleConfig config = isFullScreen ? current.fullScreen : current.portrait;
    switch (type) {
      case SubtitleElementType.original:
        if (bold != null) {
          await prefs.setBool('${_keyBoldOrig}_$prefix', bold);
          config = config.copyWith(isBoldOriginal: bold);
        }
        if (italic != null) {
          await prefs.setBool('${_keyItalicOrig}_$prefix', italic);
          config = config.copyWith(isItalicOriginal: italic);
        }
        break;
      case SubtitleElementType.additional:
        if (bold != null) {
          await prefs.setBool('${_keyBoldAdd}_$prefix', bold);
          config = config.copyWith(isBoldAdditional: bold);
        }
        if (italic != null) {
          await prefs.setBool('${_keyItalicAdd}_$prefix', italic);
          config = config.copyWith(isItalicAdditional: italic);
        }
        break;
      case SubtitleElementType.translation:
        if (bold != null) {
          await prefs.setBool('${_keyBoldTrans}_$prefix', bold);
          config = config.copyWith(isBoldTranslation: bold);
        }
        if (italic != null) {
          await prefs.setBool('${_keyItalicTrans}_$prefix', italic);
          config = config.copyWith(isItalicTranslation: italic);
        }
        break;
    }

    state = AsyncData(isFullScreen
        ? current.copyWith(fullScreen: config)
        : current.copyWith(portrait: config));
  }

  Future<void> updateFontSize(bool isFullScreen, SubtitleElementType type, double size) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value!;
    final prefix = isFullScreen ? 'fs' : 'port';

    SubtitleConfig config = isFullScreen ? current.fullScreen : current.portrait;
    switch (type) {
      case SubtitleElementType.original:
        await prefs.setDouble('${_keyFontOrig}_$prefix', size);
        config = config.copyWith(fontSizeOriginal: size);
        break;
      case SubtitleElementType.additional:
        await prefs.setDouble('${_keyFontAdd}_$prefix', size);
        config = config.copyWith(fontSizeAdditional: size);
        break;
      case SubtitleElementType.translation:
        await prefs.setDouble('${_keyFontTrans}_$prefix', size);
        config = config.copyWith(fontSizeTranslation: size);
        break;
    }

    state = AsyncData(isFullScreen
        ? current.copyWith(fullScreen: config)
        : current.copyWith(portrait: config));
  }

  Future<void> updateGlobalScale(bool isFullScreen, double scale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value!;
    final prefix = isFullScreen ? 'fs' : 'port';

    final oldConfig = isFullScreen ? current.fullScreen : current.portrait;
    final oldScale = oldConfig.globalScale;
    final ratio = scale / oldScale;

    final newOrig = (oldConfig.fontSizeOriginal * ratio).clamp(10.0, 50.0);
    final newAdd = (oldConfig.fontSizeAdditional * ratio).clamp(10.0, 50.0);
    final newTrans = (oldConfig.fontSizeTranslation * ratio).clamp(10.0, 50.0);

    await prefs.setDouble('${_keyFontOrig}_$prefix', newOrig);
    await prefs.setDouble('${_keyFontAdd}_$prefix', newAdd);
    await prefs.setDouble('${_keyFontTrans}_$prefix', newTrans);
    await prefs.setDouble('${_keyGlobalScale}_$prefix', scale);

    final newConfig = oldConfig.copyWith(
      fontSizeOriginal: newOrig,
      fontSizeAdditional: newAdd,
      fontSizeTranslation: newTrans,
      globalScale: scale,
    );

    state = AsyncData(isFullScreen
        ? current.copyWith(fullScreen: newConfig)
        : current.copyWith(portrait: newConfig));
  }

  Future<void> updateFsGroupOffset(double offset) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value!;
    await prefs.setDouble(_keyFSGroupOffset, offset);
    state = AsyncData(current.copyWith(fullScreen: current.fullScreen.copyWith(groupOffset: offset)));
  }

  Future<void> updateFsBackground(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value!;
    await prefs.setBool(_keyFSBgEnabled, enabled);
    state = AsyncData(current.copyWith(fullScreen: current.fullScreen.copyWith(backgroundEnabled: enabled)));
  }

  Future<void> updateFsBgColor(int color) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value!;
    await prefs.setInt(_keyFSBgColor, color);
    state = AsyncData(current.copyWith(fullScreen: current.fullScreen.copyWith(backgroundColor: color)));
  }
}

final subtitleSettingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SubtitleSettingsNotifier, SubtitleSettingsState>(
  () => SubtitleSettingsNotifier(),
);
