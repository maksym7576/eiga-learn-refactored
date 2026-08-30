import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/widgets/videoUploating/components/UploadingTheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'languagePreviewWidget.dart';

class LanguageWidget extends ConsumerWidget {
  final String language;
  final LanguageType type;

  const LanguageWidget({
    super.key,
    required this.language,
    required this.type,
});

  Future<void> setLanguage(WidgetRef ref, String language) async {
    if (type == LanguageType.original) {
      ref.read(languageProvider.notifier).setOriginal(language);
    }
    if (type == LanguageType.translation) {
      ref.read(languageProvider.notifier).setTarget(language);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateLan = ref.watch(languageProvider);
    final original = stateLan.original;
    final translation = stateLan.target;

    final theme = UploadingTheme.of(context);

    final bool isSelected = (type == LanguageType.original && language == original) ||
        (type == LanguageType.translation && language == translation);

    final bool isOccupied = (type == LanguageType.original && language == translation) ||
        (type == LanguageType.translation && language == original);
    
    // Sentence case
    final String displayLanguage = language.isNotEmpty 
        ? language[0].toUpperCase() + language.substring(1).toLowerCase() 
        : language;

    return GestureDetector(
      onTap: isOccupied
          ? null
          : () {
              setLanguage(ref, language);
            },
      child: Opacity(
        opacity: isOccupied ? 0.4 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.selectedCardBackground : theme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? theme.selectedCardBorder : theme.cardBorder,
              width: isSelected ? 2.0 : 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: theme.selectedCardBorder.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ] : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayLanguage,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isOccupied
                        ? theme.occupiedText
                        : isSelected
                            ? theme.selectedText
                            : theme.normalText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (isSelected)
                Icon(Icons.check_circle, color: theme.checkIconColor, size: 20)
              else if (isOccupied)
                Icon(Icons.lock, color: theme.lockIconColor, size: 18)
              else
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.unselectedCircleBorder,
                      width: 2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
