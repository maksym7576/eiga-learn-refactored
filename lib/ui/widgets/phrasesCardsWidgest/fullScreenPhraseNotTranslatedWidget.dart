import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenPhraseNotTranslatedWidget extends StatelessWidget {
  final PhraseObject phraseObject;

  const FullScreenPhraseNotTranslatedWidget({
    super.key,
    required this.phraseObject,
  });

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(offset: Offset(-1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
      Shadow(offset: Offset(-1.5, 1.5), color: Colors.black),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            phraseObject.originalPhrase ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
                phraseObject.isTranslating ? 'Translating...' : 'Not translated',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.yellowAccent,
                  fontStyle: FontStyle.italic,
                  shadows: [Shadow(offset: Offset(1, 1), color: Colors.black)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
