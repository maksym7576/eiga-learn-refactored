import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/widgets/playerWidgets/readingTypeSelectorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/timerShiftEditorWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dialogs/AppDialog.dart';
import '../subtitles/AiRequestStatusWidget.dart';

class VideoSettingsNotFullScreenWidget extends ConsumerWidget {
  VideoSettingsNotFullScreenWidget({super.key});

  void _showTimeEditDialog(BuildContext context) async {
      await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "ModelsLabel",
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: TimeshiftEditorWidget(),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: FadeTransition(opacity: anim1, child: child),
          );
        },
      );
  }

  void _showAiStatusDialog(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "AiStatusLabel",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const SingleChildScrollView(
                    child: AiRequestStatusWidget(), // Виклик правильного віджета
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }



  void _showReadingTypeDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      barrierLabel: "ModelsLabel",
      child: const ReadingTypeSelectorWidget(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoId = ref.watch(playerIdProvider);

    final phrasesAsync = ref.watch(phraseListProvider(videoId!));
    final subtitlesEnabled = ref.watch(autoScrollProvider);
    return phrasesAsync.when(
      data: (phrases) {
        final totalCount = phrases.length;
        final translatedCount = phrases
            .where((phrase) => phrase.isTranslated)
            .length;
        final translatingCount = phrases
            .where((phrase) => phrase.isTranslating)
            .length;
        final notTranslatedCount =
            totalCount - translatedCount - translatingCount;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: Colors.deepPurpleAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: () {
                    ref.read(autoScrollProvider.notifier).toggle();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                      color: subtitlesEnabled
                          ? Colors.deepPurpleAccent
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subtitlesEnabled ? 'Subtitle ON' : 'Subtitle Off',
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitlesEnabled ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => _showTimeEditDialog(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Edit Subtitle',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => _showTimeEditDialog(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Edit Time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => _showAiStatusDialog(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'AI Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => _showReadingTypeDialog(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Reading type',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                _startItem('Total', totalCount.toString()),
                const SizedBox(width: 3),
                _startItem('Translated', translatedCount.toString()),
                const SizedBox(width: 3),
                _startItem('Translating', translatingCount.toString()),
                const SizedBox(width: 3),
                _startItem('Remaining', notTranslatedCount.toString()),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => SizedBox(
        width: double.infinity,
        child: Text('Error loading phrases'),
      ),
      loading: () => const SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(child: CupertinoActivityIndicator()),
      ),
    );
  }

  Widget _startItem(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurpleAccent.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }
}
