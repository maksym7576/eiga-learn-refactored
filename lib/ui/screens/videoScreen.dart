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
    final videoHeight = ref.watch(videoHeightProvider);

    return Column(
      children: [
        Stack(
          children: [
            VideoPlayerWidget(showDivider: false),
            Positioned(
              top: 10,
              left: 10,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  child: IconButton(
                    onPressed: () => context.go('/main'),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Налаштування (під відео)
        VideoSettingsNotFullScreenWidget(
          isExpanded: videoHeight > 300, // Адаптивність за висотою
        ),

        // Розділювач для вертикального рисайзу (під налаштуваннями)
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
      children: [
        // Ліва частина: Відео + Налаштування
        SizedBox(
          width: leftWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Плеєр із заокругленими кутами для сучасного вигляду
              // Обмежуємо висоту відео, щоб завжди залишалось місце для налаштувань
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: VideoPlayerWidget(isLandscapeSplit: true),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Налаштування адаптивно заповнюють простір
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: VideoSettingsNotFullScreenWidget(isExpanded: true),
                ),
              ),
            ],
          ),
        ),
        
        // Розділювач для горизонтального рисайзу
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newRatio = details.globalPosition.dx / screenWidth;
            if (newRatio > 0.1 && newRatio < 0.9) { // Більший діапазон
              ref.read(videoSplitRatioProvider.notifier).state = newRatio;
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: Container(
              width: 10,
              color: Colors.deepPurple[100],
              child: Center(
                child: Container(
                  width: 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[300],
                    borderRadius: BorderRadius.circular(2),
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
