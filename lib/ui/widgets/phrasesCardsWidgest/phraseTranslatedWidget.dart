import 'package:eiga/backend/data/dto/PhraseDataDTO.dart';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../styles/phraseListStyles.dart';

class PhraseTranslatedWidget extends ConsumerStatefulWidget {
  final PhraseObject phraseObject;

  const PhraseTranslatedWidget({super.key, required this.phraseObject});

  @override
  ConsumerState<PhraseTranslatedWidget> createState() => _PhraseTranslatedWidgetState();
}

class _PhraseTranslatedWidgetState extends ConsumerState<PhraseTranslatedWidget> {
  late Future<PhraseDataDTO> _praseDataDTOFuture;
  int? _selectedBlockId;

  @override
  void initState() {
    super.initState();
    _praseDataDTOFuture = _loadData();
  }

  Future<PhraseDataDTO> _loadData() async {
    final blockService = ref.read(blockServiceProvider);
    final wordService = ref.read(wordServiceProvider);

    final blocks = await blockService.getBlocksForPhrase(widget.phraseObject.id);
    blocks.sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));

    List<WordObject> allWords = [];
    for (var block in blocks) {
      allWords.addAll(await wordService.getWordsBlocks([block.id]));
    }
    allWords.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));

    return PhraseDataDTO(blocks, allWords);
  }

  void _toggleSelection(int? blockId) {
    if (blockId == null) return;
    setState(() => _selectedBlockId = (_selectedBlockId == blockId) ? null : blockId);
  }

  String _getVersionText(WordObject word, String key) {
    try {
      // Спробуємо знайти за основним ключем
      var item = word.versions.where((v) => v.key == key).firstOrNull;

      // Якщо не знайшли і шукаємо romaji, спробуємо знайти за застарілим ключем romanji
      if (item == null && key == 'romaji') {
        item = word.versions.where((v) => v.key == 'romanji').firstOrNull;
      }

      return item?.text ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final readingSettings = ref.watch(readingTypeNotifierProvider).value;
    final mainOption = readingSettings?.mainOption ?? 'original';
    final additionalOption = readingSettings?.additionalOptions ?? '';

    return FutureBuilder<PhraseDataDTO>(
      future: _praseDataDTOFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 40,
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text(
            'Error to load data',
            textAlign: TextAlign.left,
          );
        }

        return _PhraseTranslatedContent(
          blocks: snapshot.data!.blocks,
          allWords: snapshot.data!.allOriginalWords,
          mainOption: mainOption,
          additionalOption: additionalOption,
          selectedBlockId: _selectedBlockId,
          onToggleSelection: _toggleSelection,
          getVersionText: _getVersionText,
        );
      },
    );
  }
}

class _PhraseTranslatedContent extends StatelessWidget {
  final List<BlockObject> blocks;
  final List<WordObject> allWords;
  final String mainOption;
  final String additionalOption;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final String Function(WordObject, String) getVersionText;

  const _PhraseTranslatedContent({
    required this.blocks,
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
  });

  @override
  Widget build(BuildContext context) {
    final blocksList = [...blocks]
      ..sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _WordsSection(
          allWords: allWords,
          mainOption: mainOption,
          additionalOption: additionalOption,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
          getVersionText: getVersionText,
        ),
        const SizedBox(height: PhraseListStyles.blockSectionSpacing),
        _BlocksSection(
          blocksList: blocksList,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
        ),
      ],
    );
  }
}

class _WordsSection extends StatelessWidget {
  final List<WordObject> allWords;
  final String mainOption;
  final String additionalOption;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final String Function(WordObject, String) getVersionText;

  const _WordsSection({
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PhraseListStyles.wordSpacing,
      runSpacing: PhraseListStyles.wordRunSpacing,
      children: allWords.map((word) {
        final mainText = getVersionText(word, mainOption).trim();
        final additionalText = getVersionText(word, additionalOption).trim();

        // Визначаємо, чи текст поміститься в один рядок
        final shouldWrap = mainText.length > 12 || additionalText.length > 12;

        return _WordItem(
          isSelected: selectedBlockId == word.blockId,
          cleanedMainWord: mainText,
          cleanedAdditionalWord: additionalText,
          onTap: () => onToggleSelection(word.blockId),
          shouldReduceFont: shouldWrap,
        );
      }).toList(),
    );
  }
}

class _WordItem extends StatelessWidget {
  final bool isSelected;
  final String cleanedMainWord;
  final String cleanedAdditionalWord;
  final VoidCallback onTap;
  final bool shouldReduceFont;

  const _WordItem({
    required this.isSelected,
    required this.cleanedMainWord,
    required this.cleanedAdditionalWord,
    required this.onTap,
    this.shouldReduceFont = false,
  });

  double _calculateOptimalFontSize(String text, double defaultSize, int maxLines) {
    // Якщо текст короткий, використовуємо стандартний розмір
    if (text.length <= 8) {
      return defaultSize;
    }

    // Якщо текст середній, трошки зменшуємо
    if (text.length <= 15) {
      return defaultSize * 0.9;
    }

    // Якщо текст довгий, зменшуємо більше
    return defaultSize * 0.75;
  }

  @override
  Widget build(BuildContext context) {
    final additionalStyle = PhraseListStyles.getWordTextStyle(
      isSelected: isSelected,
      isAdditional: true,
    );
    final mainStyle = PhraseListStyles.getWordTextStyle(
      isSelected: isSelected,
      isAdditional: false,
    );

    final additionalDefaultSize = additionalStyle.fontSize ?? 12;
    final mainDefaultSize = mainStyle.fontSize ?? 14;

    final additionalFontSize = shouldReduceFont
        ? _calculateOptimalFontSize(cleanedAdditionalWord, additionalDefaultSize, 2)
        : additionalDefaultSize;

    final mainFontSize = shouldReduceFont
        ? _calculateOptimalFontSize(cleanedMainWord, mainDefaultSize, 2)
        : mainDefaultSize;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: PhraseListStyles.durationWordAnimation,
        curve: PhraseListStyles.curveWord,
        padding: const EdgeInsets.all(PhraseListStyles.wordPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cleanedAdditionalWord,
              softWrap: true,
              maxLines: shouldReduceFont ? 2 : null,
              overflow: TextOverflow.ellipsis,
              style: additionalStyle.copyWith(fontSize: additionalFontSize),
            ),
            Text(
              cleanedMainWord,
              softWrap: true,
              maxLines: shouldReduceFont ? 2 : null,
              overflow: TextOverflow.ellipsis,
              style: mainStyle.copyWith(fontSize: mainFontSize),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlocksSection extends StatelessWidget {
  final List<BlockObject> blocksList;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;

  const _BlocksSection({
    required this.blocksList,
    required this.selectedBlockId,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: blocksList.map((block) {
          final blockText = block.blockTranslation?.trim() ?? '';
          return TextSpan(
            text: '$blockText\u2009',
            style: PhraseListStyles.getBlockTextStyle(
              isSelected: selectedBlockId == block.id,
            ).copyWith(
              fontSize: (PhraseListStyles.getBlockTextStyle(isSelected: selectedBlockId == block.id).fontSize ?? 14) * 0.9,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => onToggleSelection(block.id),
          );
        }).toList(),
      ),
      softWrap: true,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
    );
  }
}
