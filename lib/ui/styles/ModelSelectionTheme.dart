import 'package:flutter/material.dart';

class ModelSelectionTheme {
  final bool isDark;

  ModelSelectionTheme({required this.isDark});

  factory ModelSelectionTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ModelSelectionTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;

  // Backgrounds
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get cardBackground => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
  Color get activeCardBackground => primaryAccent.withValues(alpha: 0.05);

  // Borders
  Color get cardBorder => isDark ? Colors.white10 : Colors.grey.shade300;
  Color get activeCardBorder => primaryAccent;

  // Text
  Color get normalText => isDark ? Colors.white : Colors.black87;
  Color get mutedText => isDark ? Colors.white38 : Colors.grey.shade500;

  // Indicators
  Color get speedIndicatorColor => Colors.blue;
  Color get powerIndicatorColor => Colors.indigo;
  Color get limitIndicatorColor => Colors.blueGrey;

  // Segment Bars
  Color get segmentOffColor => isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05);

  // Button Styles
  ButtonStyle segmentButtonStyle() {
    return ButtonStyle(
      visualDensity: VisualDensity.compact,
    );
  }
}
