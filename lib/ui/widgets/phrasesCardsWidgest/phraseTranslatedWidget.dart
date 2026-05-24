import 'package:eiga/backend/data/dto/PhraseDataDTO.dart';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhraseTranslatedWidget extends ConsumerStatefulWidget {
  final PhraseObject phraseObject;

  const PhraseTranslatedWidget({super.key, required this.phraseObject});

  @override
  ConsumerState<PhraseTranslatedWidget> createState() =>
      _PhraseTranslatedWidgetState();
}

class _PhraseTranslatedWidgetState
    extends ConsumerState<PhraseTranslatedWidget> {
  late Future<PhraseDataDTO> _praseDataDTOFuture;
  int? _selectedBlockId;

  @override
  void initState() {
    super.initState();
    _praseDataDTOFuture = loadData();
  }

  Future<PhraseDataDTO> loadData() async {
    final blockService = ref.read(blockServiceProvider);
    final wordService = ref.read(wordServiceProvider);

    final blocks = await blockService.getBlocksForPhrase(
      widget.phraseObject.id,
    );
    blocks.sort(
      (a, b) => a.translatedPositionIndex.first.compareTo(
        b.translatedPositionIndex.first,
      ),
    );

    List<WordObject> allWords = [];
    for (var block in blocks) {
      final words = await wordService.getWordsBlocks([block.id]);
      allWords.addAll(words);
    }

    allWords.sort(
      (a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0),
    );
    return PhraseDataDTO(blocks, allWords);
  }

  void toggleSelection(int? blockId) {
    if (blockId == null) return;
    setState(() {
      _selectedBlockId = (_selectedBlockId == blockId) ? null : blockId;
    });
  }

  String _getVersionText(WordObject word, String key) {
    try {
      return word.versions.firstWhere((v) => v.key == key).text ?? '';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final readingSettings = ref.watch(readingTypeNotifierProvider).value;
    final mainOption = readingSettings?.mainOption ?? 'original';
    final additionalOption = readingSettings?.additionalOptions ?? '';
    return FutureBuilder(
      future: _praseDataDTOFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Error to load data'));
        }

        final data = snapshot.data!;
        final blocks = data.blocks;
        final blocksList = List.from(blocks)
          ..sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));
        final allWords = data.allOriginalWords;
        return Align(
          alignment: Alignment.centerLeft,
          child:
          Padding(
          padding: EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Wrap(
                  spacing: 1.0,
                  runSpacing: 5.0,
                  children: allWords.map((word) {
                    final isSelected =
                        _selectedBlockId != null &&
                        _selectedBlockId == word.blockId;
                    final cleanedMainWord = _getVersionText(word, mainOption).trim();
                    final cleanedAdditionalWord = _getVersionText(word, additionalOption).trim();

                    return GestureDetector(
                      onTap: () => toggleSelection(word.blockId),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        child: Column(
                          children: [
                            Text(
                              cleanedAdditionalWord,
                              style: TextStyle(
                                fontSize: 8.0,
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.deepPurpleAccent.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              cleanedMainWord,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.deepPurpleAccent.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              RichText(
                text: TextSpan(
                  children: blocksList.map((block) {
                    final cleanedText = block.blockTranslation?.trim() ?? '';
                    final isSelected = _selectedBlockId == block.id;

                    return TextSpan(
                      text: '$cleanedText ',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.deepPurpleAccent.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () => toggleSelection(block.id),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        );
      },
    );
  }
}
