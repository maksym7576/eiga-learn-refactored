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

    final origSize = config?.fontSizeOriginal ?? 28.0;
    final addSize = config?.fontSizeAdditional ?? 16.0;
    
    final shadowOffset = origSize * 0.05;
    final shadow = [
      Shadow(offset: Offset(-shadowOffset, -shadowOffset), color: Colors.black),
      Shadow(offset: Offset(shadowOffset, -shadowOffset), color: Colors.black),
      Shadow(offset: Offset(shadowOffset, shadowOffset), color: Colors.black),
      Shadow(offset: Offset(-shadowOffset, shadowOffset), color: Colors.black),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: config?.backgroundEnabled == true 
            ? Color(config!.backgroundColor) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            phraseObject.originalPhrase ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: origSize,
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
              SizedBox(
                width: addSize * 1.0,
                height: addSize * 1.0,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.yellowAccent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                phraseObject.isTranslating ? 'Перекладаємо...' : 'Не перекладено',
                style: TextStyle(
                  fontSize: addSize,
                  color: Colors.yellowAccent,
                  fontStyle: config?.isItalicAdditional == true ? FontStyle.italic : FontStyle.italic,
                  shadows: [Shadow(offset: Offset(shadowOffset, shadowOffset), color: Colors.black)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
