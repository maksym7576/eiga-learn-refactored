import 'package:flutter/material.dart';

enum SubtitleElementType { original, additional, translation }

class SubtitleElementStyle {
  final double fontSize;
  final int color;
  final int selectionColor;
  final bool isBold;
  final bool isItalic;

  const SubtitleElementStyle({
    required this.fontSize,
    required this.color,
    required this.selectionColor,
    required this.isBold,
    required this.isItalic,
  });

  SubtitleElementStyle copyWith({
    double? fontSize,
    int? color,
    int? selectionColor,
    bool? isBold,
    bool? italic,
  }) {
    return SubtitleElementStyle(
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      selectionColor: selectionColor ?? this.selectionColor,
      isBold: isBold ?? this.isBold,
      isItalic: italic ?? this.isItalic,
    );
  }
}

class SubtitleConfig {
  final String presetName;
  final bool backgroundEnabled;
  final int backgroundColor;
  final double fontSizeOriginal;
  final double fontSizeAdditional;
  final double fontSizeTranslation;
  final bool isBoldOriginal;
  final bool isBoldAdditional;
  final bool isBoldTranslation;
  final bool isItalicOriginal;
  final bool isItalicAdditional;
  final bool isItalicTranslation;
  final double groupOffset;
  final double globalScale;

  const SubtitleConfig({
    required this.presetName,
    required this.backgroundEnabled,
    required this.backgroundColor,
    required this.fontSizeOriginal,
    required this.fontSizeAdditional,
    required this.fontSizeTranslation,
    required this.isBoldOriginal,
    required this.isBoldAdditional,
    required this.isBoldTranslation,
    required this.isItalicOriginal,
    required this.isItalicAdditional,
    required this.isItalicTranslation,
    required this.groupOffset,
    required this.globalScale,
  });

  SubtitleElementStyle get originalStyle => SubtitleElementStyle(
        fontSize: fontSizeOriginal * globalScale,
        color: 0xFFFFFFFF,
        selectionColor: 0xFFFFFF00,
        isBold: isBoldOriginal,
        isItalic: isItalicOriginal,
      );

  SubtitleElementStyle get additionalStyle => SubtitleElementStyle(
        fontSize: fontSizeAdditional * globalScale,
        color: 0xFFFFFFFF,
        selectionColor: 0xFFFFFF00,
        isBold: isBoldAdditional,
        isItalic: isItalicAdditional,
      );

  SubtitleElementStyle get translationStyle => SubtitleElementStyle(
        fontSize: fontSizeTranslation * globalScale,
        color: 0xFFFFFFFF,
        selectionColor: 0xFFFFFF00,
        isBold: isBoldTranslation,
        isItalic: isItalicTranslation,
      );

  SubtitleConfig copyWith({
    String? presetName,
    bool? backgroundEnabled,
    int? backgroundColor,
    double? fontSizeOriginal,
    double? fontSizeAdditional,
    double? fontSizeTranslation,
    bool? isBoldOriginal,
    bool? isBoldAdditional,
    bool? isBoldTranslation,
    bool? isItalicOriginal,
    bool? isItalicAdditional,
    bool? isItalicTranslation,
    double? groupOffset,
    double? globalScale,
  }) {
    return SubtitleConfig(
      presetName: presetName ?? this.presetName,
      backgroundEnabled: backgroundEnabled ?? this.backgroundEnabled,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontSizeOriginal: fontSizeOriginal ?? this.fontSizeOriginal,
      fontSizeAdditional: fontSizeAdditional ?? this.fontSizeAdditional,
      fontSizeTranslation: fontSizeTranslation ?? this.fontSizeTranslation,
      isBoldOriginal: isBoldOriginal ?? this.isBoldOriginal,
      isBoldAdditional: isBoldAdditional ?? this.isBoldAdditional,
      isBoldTranslation: isBoldTranslation ?? this.isBoldTranslation,
      isItalicOriginal: isItalicOriginal ?? this.isItalicOriginal,
      isItalicAdditional: isItalicAdditional ?? this.isItalicAdditional,
      isItalicTranslation: isItalicTranslation ?? this.isItalicTranslation,
      groupOffset: groupOffset ?? this.groupOffset,
      globalScale: globalScale ?? this.globalScale,
    );
  }
}

class SubtitleSettingsState {
  final SubtitleConfig fullScreen;
  final SubtitleConfig portrait;

  const SubtitleSettingsState({
    required this.fullScreen,
    required this.portrait,
  });

  SubtitleSettingsState copyWith({
    SubtitleConfig? fullScreen,
    SubtitleConfig? portrait,
  }) {
    return SubtitleSettingsState(
      fullScreen: fullScreen ?? this.fullScreen,
      portrait: portrait ?? this.portrait,
    );
  }
}
