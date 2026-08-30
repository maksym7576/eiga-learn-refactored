import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';
import '../../dialogs/AppBottomSheet.dart';
import '../languagePreview/languagePreviewWidget.dart';

class LanguageButtonWidget extends StatelessWidget {
  final String original;
  final String translation;

  const LanguageButtonWidget({super.key, required this.original, required this.translation});

  void _showAllLanguages(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    AppBottomSheet.show(
      context: context,
      barrierLabel: "ModelsLabel",
      heightFactor: 0.9,
      backgroundColor: theme.backgroundColor,
      child: const LanguagePreviewWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasLanguages = original.isNotEmpty && translation.isNotEmpty;
    final hasOriginal = original.isNotEmpty;
    final hasTranslation = translation.isNotEmpty;

    final baseColor = hasLanguages ? colorScheme.primary : colorScheme.onSurface;
    final background = hasLanguages
        ? colorScheme.primaryContainer.withValues(alpha: isDark ? 0.3 : 0.5)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    
    final borderColor = hasLanguages 
        ? colorScheme.primary.withValues(alpha: 0.5) 
        : colorScheme.outline.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: () => _showAllLanguages(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: hasLanguages ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasOriginal ? original : 'original',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasOriginal ? colorScheme.primary : baseColor.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_right_alt,
              size: 20,
              color: hasLanguages ? colorScheme.primary : baseColor.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
            Text(
              hasTranslation ? translation : 'translation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasTranslation ? colorScheme.primary : baseColor.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
