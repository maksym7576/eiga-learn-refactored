import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/phrasesListNotFullScreenWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoPlayerWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoSettingsNotFullScreenWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/videoDataProviders.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(translationProvider);
    final splitRatio = ref.watch(videoSplitRatioProvider);
    final isFullscreen = ref.watch(isFullScreenProvider);

    final orientation = MediaQuery.of(context).orientation;
    // Якщо ми в повноекранному режимі, форсуємо ландшафтний макет, 
    // щоб уникнути стрибків інтерфейсу під оверлеєм плеєра.
    final effectiveOrientation = isFullscreen ? Orientation.landscape : orientation;

    return Scaffold(
      body: effectiveOrientation == Orientation.landscape
          ? _buildLandscapeLayout(context, splitRatio)
          : _buildPortraitLayout(context),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        VideoPlayerWidget(showDivider: false),

        // Розділювач для вертикального рисайзу (між плеєром і налаштуваннями)
        GestureDetector(
          onVerticalDragUpdate: (details) {
            final currentHeight = ref.read(videoHeightProvider);
            double newHeight = currentHeight + details.delta.dy;
            
            // Обмеження: мінімум 150, максимум 70% екрана
            if (newHeight < 150) newHeight = 150;
            if (newHeight > screenHeight * 0.7) newHeight = screenHeight * 0.7;
            
            ref.read(videoHeightProvider.notifier).state = newHeight;
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeRow,
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.deepPurple[50],
              child: Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Налаштування (під розділювачем)
        const VideoSettingsNotFullScreenWidget(),

        // Список фраз займає весь залишок місця
        const Expanded(
          child: PhraseListNotFullScreenWidget(),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, double splitRatio) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftWidth = screenWidth * splitRatio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Забезпечуємо повну висоту
      children: [
        // Ліва частина: Відео + Налаштування
        Container(
          width: leftWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade900,
                Colors.black,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16), // Відступ зверху
              
              // Плеєр з закругленими кутами та відступами по боках
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: VideoPlayerWidget(isLandscapeSplit: true),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: VideoSettingsNotFullScreenWidget(),
              ),
            ],
          ),
        ),
        
        // Розділювач для горизонтального рисайзу
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newRatio = details.globalPosition.dx / screenWidth;
            if (newRatio > 0.1 && newRatio < 0.9) {
              ref.read(videoSplitRatioProvider.notifier).state = newRatio;
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: Container(
              width: 8,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Права частина: Картки (фрази)
        const Expanded(
          child: PhraseListNotFullScreenWidget(),
        ),
      ],
    );
  }
}
