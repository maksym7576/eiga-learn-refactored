import 'package:flutter/material.dart';

class PlayerSettingsTheme {
  final bool isDark;

  PlayerSettingsTheme({required this.isDark});

  factory PlayerSettingsTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return PlayerSettingsTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get sectionBackground => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.indigo.withValues(alpha: 0.02);
  Color get cardBackground => isDark ? const Color(0xFF2C2C2E) : Colors.white;
  Color get normalText => isDark ? Colors.white : Colors.black87;
  Color get mutedText => isDark ? Colors.white38 : Colors.black45;

  // Specifics
  Color get tileActiveBackground => primaryAccent.withValues(alpha: 0.1);
  Color get tileBorder => isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05);
  Color get tileActiveBorder => primaryAccent;

  // Slider
  Color get sliderActive => primaryAccent;
  Color get sliderInactive => primaryAccent.withValues(alpha: 0.2);

  // Badge
  Color get badgeBackground => primaryAccent.withValues(alpha: 0.08);

  // Settings Bar (Not Full Screen)
  Color get barBackground => primaryAccent.withValues(alpha: isDark ? 0.12 : 0.08);
  Color get barBorder => primaryAccent.withValues(alpha: isDark ? 0.2 : 0.15);
  
  Color get chipInactiveBackground => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.indigo.withValues(alpha: 0.04);
  Color get chipInactiveBorder => isDark ? Colors.white.withValues(alpha: 0.1) : Colors.indigo.withValues(alpha: 0.08);
  
  List<BoxShadow> get chipActiveShadow => [
    BoxShadow(
      color: primaryAccent.withValues(alpha: isDark ? 0.3 : 0.2),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    )
  ];

  // Action Buttons
  Color get actionButtonBackground => isDark ? Colors.white.withValues(alpha: 0.06) : Colors.indigo.withValues(alpha: 0.05);
  Color get actionButtonBorder => isDark ? Colors.white.withValues(alpha: 0.1) : Colors.indigo.withValues(alpha: 0.1);

  // Icon Palette (Standardized to Indigo)
  Color get iconSubtitles => primaryAccent;
  Color get iconReading => primaryAccent;
  Color get iconAiInsights => primaryAccent;
  Color get iconSync => primaryAccent;
  Color get iconErrors => const Color(0xFFEF4444); // Keep red for errors but consistent style
}
