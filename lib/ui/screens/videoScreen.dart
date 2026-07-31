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

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            // У ландшафтному режимі не використовуємо глобальний SafeArea, 
            // щоб відео могло займати весь простір ліворуч.
            return _buildLandscapeLayout(context, splitRatio);
          } else {
            return _buildPortraitLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30), // Відступ зверху
        // Прибрали Safe Area з build(), додаємо відступ тут, якщо потрібно, або просто Stack
        Stack(
          children: [
              const VideoPlayerWidget(),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () => context.go('/main'),
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Налаштування
          const VideoSettingsNotFullScreenWidget(),
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
            children: [
              // Відео без заливки, вгорі
              const Flexible(
                child: VideoPlayerWidget(isLandscapeSplit: true),
              ),
              
              // Налаштування
              const VideoSettingsNotFullScreenWidget(),
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
