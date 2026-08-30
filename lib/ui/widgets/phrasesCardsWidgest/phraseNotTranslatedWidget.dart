import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/subtitle_settings_provider.dart';
import 'package:eiga/ui/styles/PhraseListTheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhraseNotTranslatedWidget extends ConsumerWidget {
  final PhraseObject phraseObject;
  final bool isActive;

  const PhraseNotTranslatedWidget({
    super.key,
    required this.phraseObject,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = PhraseListTheme.of(context);
    final subtitleSettings = ref.watch(subtitleSettingsNotifierProvider).value;
    final config = subtitleSettings?.portrait;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        phraseObject.originalPhrase ?? '',
        style: theme.getPhraseStyle(isActive: isActive).copyWith(
          fontSize: (config?.fontSizeOriginal ?? 17) * (config?.globalScale ?? 1.0),
          fontWeight: config?.isBoldOriginal == true ? FontWeight.bold : null,
          fontStyle: config?.isItalicOriginal == true ? FontStyle.italic : null,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}