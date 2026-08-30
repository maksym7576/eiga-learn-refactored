import 'package:flutter/material.dart';

class VideoListTheme {
  final bool isDark;

  VideoListTheme({required this.isDark});

  factory VideoListTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return VideoListTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent (Neutral Indigo/Slate)
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;

  // Grid Layout
  EdgeInsets get gridPadding => const EdgeInsets.all(12);
  double get crossAxisSpacing => 12;
  double get mainAxisSpacing => 12;
  double get childAspectRatio => 3 / 4;

  // Empty State
  Color get iconContainerColor => primaryAccent.withValues(alpha: 0.08);
  Color get iconColor => primaryAccent.withValues(alpha: 0.6);
  Color get titleColor => primaryAccent.withValues(alpha: 0.8);
  Color get subtitleColor => isDark ? Colors.white60 : Colors.grey.shade600;

  TextStyle get emptyStateTitleStyle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: titleColor,
  );

  TextStyle get emptyStateSubtitleStyle => TextStyle(
    fontSize: 13,
    color: subtitleColor,
  );
}
