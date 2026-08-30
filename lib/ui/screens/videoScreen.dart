import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/phrasesListNotFullScreenWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoPlayerWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoSettingsNotFullScreenWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/FlickManagerState.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final orientation = MediaQuery.of(context).orientation;
    final effectiveOrientation = isFullscreen ? Orientation.landscape : orientation;

    // Neutral colors for dividers and backgrounds
    final backgroundColor = isDark ? const Color(0xFF1C1C1E) : Colors.grey.shade50;
    final dividerColor = isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
    final handleColor = isDark ? Colors.white24 : Colors.black12;

    return PopScope(
      canPop: !isFullscreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (isFullscreen) {
          final flickManager = ref.read(flickManagerProvider).flickManager;
          flickManager?.flickControlManager?.exitFullscreen();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: effectiveOrientation == Orientation.landscape
            ? _buildLandscapeLayout(context, splitRatio, backgroundColor, dividerColor, handleColor)
            : _buildPortraitLayout(context, backgroundColor, dividerColor, handleColor),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, Color bgColor, Color divColor, Color handleColor) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        VideoPlayerWidget(showDivider: false),

        GestureDetector(
          onVerticalDragUpdate: (details) {
            final currentHeight = ref.read(videoHeightProvider);
            double newHeight = currentHeight + details.delta.dy;
            
            if (newHeight < 150) newHeight = 150;
            if (newHeight > screenHeight * 0.7) newHeight = screenHeight * 0.7;
            
            ref.read(videoHeightProvider.notifier).state = newHeight;
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeRow,
            child: Container(
              height: 12,
              width: double.infinity,
              color: divColor,
              child: Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),

        const VideoSettingsNotFullScreenWidget(),

        const Expanded(
          child: PhraseListNotFullScreenWidget(),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, double splitRatio, Color bgColor, Color divColor, Color handleColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftWidth = screenWidth * splitRatio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: leftWidth,
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: VideoPlayerWidget(isLandscapeSplit: true),
                  ),
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: VideoSettingsNotFullScreenWidget(),
              ),
            ],
          ),
        ),
        
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
              width: 12,
              color: divColor,
              child: Center(
                child: Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),

        const Expanded(
          child: PhraseListNotFullScreenWidget(),
        ),
      ],
    );
  }
}
