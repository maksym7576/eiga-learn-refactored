


import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'languagePreviewStyles.dart';
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

    final theme = LanguagePreviewTheme.of(context);

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.selectedCardBackground : theme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? theme.selectedCardBorder : theme.cardBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayLanguage,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
              if (isSelected)
                Icon(Icons.check, color: theme.checkIconColor, size: 20)
              else if (isOccupied)
                Icon(Icons.lock_outline, color: theme.lockIconColor, size: 18)
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