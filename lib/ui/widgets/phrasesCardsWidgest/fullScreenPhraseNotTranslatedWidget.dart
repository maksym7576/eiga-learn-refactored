import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/subtitle_settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FullScreenPhraseNotTranslatedWidget extends ConsumerWidget {
  final PhraseObject phraseObject;

  const FullScreenPhraseNotTranslatedWidget({
    super.key,
    required this.phraseObject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleSettings = ref.watch(subtitleSettingsNotifierProvider).value;
    final config = subtitleSettings?.fullScreen;

    const shadow = [
      Shadow(offset: Offset(-1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
      Shadow(offset: Offset(-1.5, 1.5), color: Colors.black),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: config?.backgroundEnabled == true 
            ? Color(config!.backgroundColor) 
            : Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            phraseObject.originalPhrase ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (config?.fontSizeOriginal ?? 28) * (config?.globalScale ?? 1.0),
              color: Colors.white,
              fontWeight: config?.isBoldOriginal == true ? FontWeight.bold : FontWeight.bold,
              fontStyle: config?.isItalicOriginal == true ? FontStyle.italic : FontStyle.normal,
              shadows: shadow,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.yellowAccent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                phraseObject.isTranslating ? 'Перекладаємо...' : 'Не перекладено',
                style: TextStyle(
                  fontSize: (config?.fontSizeAdditional ?? 16) * (config?.globalScale ?? 1.0),
                  color: Colors.yellowAccent,
                  fontStyle: config?.isItalicAdditional == true ? FontStyle.italic : FontStyle.italic,
                  shadows: const [Shadow(offset: Offset(1, 1), color: Colors.black)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
