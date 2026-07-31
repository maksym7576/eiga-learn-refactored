import 'package:eiga/backend/data/dto/PhraseDataDTO.dart';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/data/models/subtitleSettings.dart';
import 'package:eiga/backend/services/petition_ai/parsers/utils/romaji_utils.dart';
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

    bool isQuoteOpen = false;
    String lastWord = '';

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0, // Динамічний відступ через padding у WordItem
      runSpacing: PhraseListStyles.wordRunSpacing,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: allWords.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;

        final mainText = getVersionText(word, mainOption).trim();
        final additionalText = getVersionText(word, additionalOption).trim();

        bool hasLeadingSpace = false;

        if (needsSpacing && index > 0 && mainText.isNotEmpty) {
          final isOpening = RomajiUtils.isOpeningPunctuation(mainText);
          final isClosing = RomajiUtils.isClosingPunctuation(mainText);
          final isNeutral = RomajiUtils.isNeutralPunctuation(mainText);

          final lastWasOpening = RomajiUtils.isOpeningPunctuation(lastWord);
          final lastWasNeutral = RomajiUtils.isNeutralPunctuation(lastWord);

          if (isNeutral) {
            // Якщо це лапка, і вона зараз "відкриває" — потрібен пробіл
            // Якщо вона "закриває" — пробіл не потрібен (вона тулиться до слова зліва)
            if (!isQuoteOpen) {
              hasLeadingSpace = !lastWasOpening;
            }
            isQuoteOpen = !isQuoteOpen;
          } else if (isOpening) {
            // Перед дужкою, що відкривається, потрібен пробіл (якщо попереду не інша відкриваюча дужка)
            hasLeadingSpace = !lastWasOpening;
          } else if (isClosing) {
            // Перед комою/крапкою пробіл не потрібен
            hasLeadingSpace = false;
          } else {
            // Звичайне слово: потрібен пробіл, якщо попереду не відкриваюча дужка/лапка
            hasLeadingSpace = !lastWasOpening && !(lastWasNeutral && isQuoteOpen);
          }
        }

        if (mainText.isNotEmpty) {
          lastWord = mainText;
        }

        final bool isOnlyPunc = RomajiUtils.isOnlyPunctuation(mainText);

        // Logic for seamless capsule:
        // A word sticks to the previous one if it's the same block AND no space between them.
        final bool sticksToPrevious = index > 0 && 
            allWords[index - 1].blockId == word.blockId && 
            !hasLeadingSpace;
        
        // A word sticks to the next one if the NEXT word has the same block and NO leading space.
        bool sticksToNext = false;
        if (index < allWords.length - 1) {
          final nextWord = allWords[index + 1];
          final nextMainText = getVersionText(nextWord, mainOption).trim();
          if (nextWord.blockId == word.blockId && nextMainText.isNotEmpty) {
             // We need to know if the NEXT word would have a leading space.
             // Let's pre-calculate or use the same logic.
             final nextIsOpening = RomajiUtils.isOpeningPunctuation(nextMainText);
             final nextIsClosing = RomajiUtils.isClosingPunctuation(nextMainText);
             final nextIsNeutral = RomajiUtils.isNeutralPunctuation(nextMainText);
             
             bool nextHasLeadingSpace = false;
             if (needsSpacing) {
                if (nextIsNeutral) {
                   // This is slightly complex because isQuoteOpen changes. 
                   // But for "sticking" we usually care about the current word being opening or next being closing.
                } else if (nextIsOpening) {
                   nextHasLeadingSpace = !RomajiUtils.isOpeningPunctuation(mainText);
                } else if (nextIsClosing) {
                   nextHasLeadingSpace = false;
                } else {
                   nextHasLeadingSpace = !RomajiUtils.isOpeningPunctuation(mainText) && 
                      !(RomajiUtils.isNeutralPunctuation(mainText) && isQuoteOpen);
                }
             }
             sticksToNext = !nextHasLeadingSpace;
          }
        }

        return _WordItem(
          isSelected: selectedBlockId == word.blockId,
          cleanedMainWord: mainText,
          cleanedAdditionalWord: isOnlyPunc ? '' : additionalText,
          onTap: () => onToggleSelection(word.blockId),
          config: config,
          needsSpacing: needsSpacing,
          hasLeadingSpace: hasLeadingSpace,
          sticksToPrevious: sticksToPrevious,
          sticksToNext: sticksToNext,
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
  final bool hasLeadingSpace;
  final bool sticksToPrevious;
  final bool sticksToNext;

  const _WordItem({
    required this.isSelected,
    required this.cleanedMainWord,
    required this.cleanedAdditionalWord,
    required this.onTap,
    this.config,
    required this.needsSpacing,
    required this.hasLeadingSpace,
    this.sticksToPrevious = false,
    this.sticksToNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final origSize = config?.fontSizeOriginal ?? PhraseListStyles.fontSizeMainWord;
    final addSize = config?.fontSizeAdditional ?? PhraseListStyles.fontSizeAdditionalWord;
    
    final double leadingSpaceWidth = hasLeadingSpace ? origSize * 0.25 : 0;

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
        padding: EdgeInsets.only(
          left: leadingSpaceWidth + (isSelected && !sticksToPrevious ? origSize * 0.1 : 0),
          right: isSelected && !sticksToNext ? origSize * 0.1 : 0,
        ),
        child: Container(
          decoration: isSelected 
            ? BoxDecoration(
                color: PhraseListStyles.getWordTextStyle(isSelected: true, isAdditional: false).color?.withValues(alpha: 0.1),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(sticksToPrevious ? 0 : 4),
                  right: Radius.circular(sticksToNext ? 0 : 4),
                ),
              )
            : null,
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
