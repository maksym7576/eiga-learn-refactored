import 'package:eiga/backend/data/dto/PhraseDataDTO.dart';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/data/models/subtitleSettings.dart';
import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/subtitle_settings_provider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/providers/FlickManagerState.dart';
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
    setState(() {
      _selectedBlockId = (_selectedBlockId == blockId) ? null : blockId;
      final controlManager = ref.read(flickManagerProvider).flickManager?.flickControlManager;
      if (_selectedBlockId != null) {
        controlManager?.pause();
      } else {
        controlManager?.play();
      }
    });
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
    final subtitleSettings = ref.watch(subtitleSettingsNotifierProvider).value;
    final video = ref.watch(currentVideoProvider).value;

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
          config: subtitleSettings?.portrait,
          originalLanguage: video?.originalLanguage,
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
  final SubtitleConfig? config;
  final String? originalLanguage;

  const _PhraseTranslatedContent({
    required this.blocks,
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
    this.config,
    this.originalLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final blocksList = [...blocks]
      ..sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _WordsSection(
          allWords: allWords,
          mainOption: mainOption,
          additionalOption: additionalOption,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
          getVersionText: getVersionText,
          config: config,
          originalLanguage: originalLanguage,
        ),
        const SizedBox(height: PhraseListStyles.blockSectionSpacing),
        _BlocksSection(
          blocksList: blocksList,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
          config: config,
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
  final SubtitleConfig? config;
  final String? originalLanguage;

  const _WordsSection({
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
    this.config,
    this.originalLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final languageConfig = ReadingTypeLanguageConfigRegistry.getConfing(originalLanguage ?? 'japanese');
    final needsSpacing = languageConfig.spacingOptions.contains(mainOption);
    final origSize = config?.fontSizeOriginal ?? PhraseListStyles.fontSizeMainWord;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: needsSpacing ? origSize * 0.1 : 0,
      runSpacing: PhraseListStyles.wordRunSpacing,
      crossAxisAlignment: WrapCrossAlignment.end, // Вирівнювання по низу для японського тексту
      children: allWords.map((word) {
        final mainText = getVersionText(word, mainOption).trim();
        final additionalText = getVersionText(word, additionalOption).trim();

        return _WordItem(
          isSelected: selectedBlockId == word.blockId,
          cleanedMainWord: mainText,
          cleanedAdditionalWord: additionalText,
          onTap: () => onToggleSelection(word.blockId),
          config: config,
          needsSpacing: needsSpacing,
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
  final SubtitleConfig? config;
  final bool needsSpacing;

  const _WordItem({
    required this.isSelected,
    required this.cleanedMainWord,
    required this.cleanedAdditionalWord,
    required this.onTap,
    this.config,
    required this.needsSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final origSize = config?.fontSizeOriginal ?? PhraseListStyles.fontSizeMainWord;
    final addSize = config?.fontSizeAdditional ?? PhraseListStyles.fontSizeAdditionalWord;

    final additionalStyle = PhraseListStyles.getWordTextStyle(
      isSelected: isSelected,
      isAdditional: true,
    ).copyWith(
      fontSize: addSize,
      fontWeight: config?.isBoldAdditional == true ? FontWeight.bold : null,
      fontStyle: config?.isItalicAdditional == true ? FontStyle.italic : null,
      height: 1.1,
    );
    final mainStyle = PhraseListStyles.getWordTextStyle(
      isSelected: isSelected,
      isAdditional: false,
    ).copyWith(
      fontSize: origSize,
      fontWeight: config?.isBoldOriginal == true ? FontWeight.bold : null,
      fontStyle: config?.isItalicOriginal == true ? FontStyle.italic : null,
      height: 1.1,
      letterSpacing: needsSpacing ? null : 0,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? origSize * 0.1 : (needsSpacing ? origSize * 0.15 : 0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Фурігана (Ruby) - показуємо лише якщо є текст
            Text(
              cleanedAdditionalWord,
              style: additionalStyle,
            ),
            // Основне слово
            Text(
              cleanedMainWord,
              style: mainStyle,
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
  final SubtitleConfig? config;

  const _BlocksSection({
    required this.blocksList,
    required this.selectedBlockId,
    required this.onToggleSelection,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final transSize = config?.fontSizeTranslation ?? PhraseListStyles.fontSizeBlock;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text.rich(
        TextSpan(
          children: blocksList.map((block) {
            final blockText = block.blockTranslation?.trim() ?? '';
            final isSelected = selectedBlockId == block.id;
            return TextSpan(
              text: '$blockText\u2009',
              style: PhraseListStyles.getBlockTextStyle(
                isSelected: isSelected,
              ).copyWith(
                fontSize: transSize,
                fontWeight: config?.isBoldTranslation == true ? FontWeight.bold : (isSelected ? FontWeight.bold : null),
                fontStyle: config?.isItalicTranslation == true ? FontStyle.italic : null,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => onToggleSelection(block.id),
            );
          }).toList(),
        ),
        softWrap: true,
        overflow: TextOverflow.visible,
        textAlign: TextAlign.center,
      ),
    );
  }
}
