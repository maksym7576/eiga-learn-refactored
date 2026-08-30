import 'package:flutter/material.dart';

class UploadingTheme {
  final bool isDark;

  UploadingTheme({required this.isDark});

  factory UploadingTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return UploadingTheme(isDark: brightness == Brightness.dark);
  }

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get titleColor => isDark ? Colors.white : Colors.black87;
  Color get subtitleColor => isDark ? Colors.white60 : Colors.black54;
  Color get closeIconColor => isDark ? Colors.white70 : Colors.black45;
  Color get dividerColor => isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
  Color get handleColor => isDark ? Colors.white24 : Colors.black12;

  // Input styles (VideoTitleField)
  Color get inputBorderColor => isDark ? Colors.white12 : Colors.black12;
  Color get focusedInputBorderColor => isDark ? Colors.white24 : Colors.black26;
  Color get inputLabelColor => isDark ? Colors.white60 : Colors.black54;

  // Tab switcher (Original/Translation)
  Color get tabSwitcherBackground => isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
  Color get activeTabBackground => selectionAccentColor;
  Color get activeTabText => isDark ? Colors.black : Colors.white;
  Color get inactiveTabBackground => Colors.transparent;
  Color get inactiveTabText => isDark ? Colors.white38 : Colors.black38;

  // Card styles (Languages & Anime Results)
  Color get cardBackground => isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade50;
  Color get cardBorder => isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
  Color get selectedCardBackground => isDark 
      ? selectionAccentColor.withValues(alpha: 0.15) 
      : selectionAccentColor.withValues(alpha: 0.08);
  Color get selectedCardBorder => selectionAccentColor;
  Color get selectedText => isDark ? Colors.white : Colors.black87;
  Color get normalText => isDark ? Colors.white : Colors.black87;
  Color get mutedText => isDark ? Colors.white38 : Colors.black38;
  Color get occupiedText => isDark ? Colors.white24 : Colors.grey.shade400;
  
  // Status icons & selection
  Color get checkIconColor => selectionAccentColor;
  Color get lockIconColor => isDark ? Colors.white24 : Colors.grey;
  Color get unselectedCircleBorder => isDark ? Colors.white24 : Colors.black12;
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get selectionBoxBackground => isDark 
      ? selectionAccentColor.withValues(alpha: 0.08) 
      : selectionAccentColor.withValues(alpha: 0.04);

  // Action Buttons
  Color get cancelButtonText => isDark ? Colors.white : Colors.black87;
  Color get addButtonBackground => isDark ? Colors.white : Colors.black;
  Color get addButtonText => isDark ? Colors.black : Colors.white;
}
