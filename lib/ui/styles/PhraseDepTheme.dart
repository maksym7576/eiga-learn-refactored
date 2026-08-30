import 'package:flutter/material.dart';

class PhraseDepTheme {
  final bool isDark;

  PhraseDepTheme({required this.isDark});

  factory PhraseDepTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return PhraseDepTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get cardBackground => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50;
  Color get cardBorder => isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.1);
  Color get normalText => isDark ? Colors.white : Colors.black87;
  Color get mutedText => isDark ? Colors.white38 : Colors.black.withValues(alpha: 0.4);

  // Badge/Order
  Color get badgeBackground => primaryAccent.withValues(alpha: 0.12);
  Color get badgeText => isDark ? Colors.white : primaryAccent;

  // Header
  Color get titleColor => isDark ? Colors.white : primaryAccent;
  Color get subtitleColor => titleColor.withValues(alpha: 0.5);

  // Buttons
  Color get searchIconColor => isDark ? Colors.white : primaryAccent;
  Color get searchIconBackground => primaryAccent.withValues(alpha: 0.1);

  // Divider
  Color get dividerColor => isDark ? Colors.white10 : Colors.black12;
}
