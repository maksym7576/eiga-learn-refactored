import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/fullScreenPhraseWidget.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/FlickManagerState.dart';

// Провайдери для рисайзу та рухання (лишаються без змін)
final videoHeightProvider = StateProvider<double>((ref) => 250);
final isDraggingProvider = StateProvider<bool>((ref) => false);

// Глобальний ключ для збереження стану FlickVideoPlayer при перемиканні орієнтації
final flickVideoPlayerKeyProvider = Provider((ref) => GlobalKey());

class VideoPlayerWidget extends ConsumerWidget {
  final double? minHeight;
  final double? maxHeight;
  final bool isLandscapeSplit;
  final bool showDivider;

  // Стабільний ключ, який зберігається однаковим і в portrait, і в
  // landscape гілці дерева — це додатковий страхувальний трос, щоб
  // Flutter не сприймав це як два різних елементи при зміні orientation.
  static const _stableKey = ValueKey('video_player_widget_stable');

  VideoPlayerWidget({
    this.minHeight = 150,
    this.maxHeight,
    this.isLandscapeSplit = false,
    this.showDivider = true,
  }) : super(key: _stableKey);

  void _handleDragUpdate(WidgetRef ref, double screenHeight, DragUpdateDetails details) {
    final maxVideoHeight = maxHeight ?? screenHeight * 0.7;
    final minVideoHeight = minHeight ?? 150;

    final currentHeight = ref.read(videoHeightProvider);
    double newHeight = currentHeight + details.delta.dy;

    if (newHeight < minVideoHeight) newHeight = minVideoHeight;
    if (newHeight > maxVideoHeight) newHeight = maxVideoHeight;

    ref.read(videoHeightProvider.notifier).state = newHeight;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('[VP_LIFECYCLE] VideoPlayerWidget.build | isLandscapeSplit=$isLandscapeSplit');

    final playerState = ref.watch(flickManagerProvider);
    final isLocked = ref.watch(isLockedVideoProvider);
    final videoHeight = ref.watch(videoHeightProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    ref.listen<Duration?>(playerSeekProvider, (previous, next) {
      if (next != null) {
        playerState.flickManager?.flickControlManager?.seekTo(next);
        Future.microtask(
              () => ref.read(playerSeekProvider.notifier).state = null,
        );
      }
    });

    if (playerState.isLoading || playerState.flickManager == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (playerState.error != null) {
      return Center(
        child: Text('Помилка завантаження відео: ${playerState.error}'),
      );
    }

    final flickManager = playerState.flickManager!;
    final flickVideoPlayerKey = ref.watch(flickVideoPlayerKeyProvider);

    final double videoRatio = flickManager
        .flickVideoManager!
        .videoPlayerController!
        .value
        .aspectRatio;
    final double aspectRatio = videoRatio > 0 ? videoRatio : 16 / 9;

    final videoPlayerPart = Container(
      height: isLandscapeSplit ? null : videoHeight,
      width: double.infinity,
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
      child: Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: FlickVideoPlayer(
            key: flickVideoPlayerKey,
            flickManager: flickManager,
            systemUIOverlay: const [],
            preferredDeviceOrientation: const [
              DeviceOrientation.portraitUp,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            preferredDeviceOrientationFullscreen: const [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            flickVideoWithControls: FlickVideoWithControls(
              controls: _buildControlsOverlay(ref, flickManager, false),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              videoFit: BoxFit.contain,
              controls: _buildControlsOverlay(ref, flickManager, true),
            ),
          ),
        ),
      ),
    );

    if (isLandscapeSplit || !showDivider) {
      return videoPlayerPart;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Відеоплеєр
        GestureDetector(
          onVerticalDragUpdate: (details) => _handleDragUpdate(ref, screenHeight, details),
          onVerticalDragStart: (_) {
            ref.read(isDraggingProvider.notifier).state = true;
          },
          onVerticalDragEnd: (_) {
            ref.read(isDraggingProvider.notifier).state = false;
          },
          child: videoPlayerPart,
        ),
        // Розділювач для рисайзу
        MouseRegion(
          cursor: SystemMouseCursors.resizeRow,
          child: GestureDetector(
            onVerticalDragUpdate: (details) => _handleDragUpdate(ref, screenHeight, details),
            onVerticalDragStart: (_) {
              ref.read(isDraggingProvider.notifier).state = true;
            },
            onVerticalDragEnd: (_) {
              ref.read(isDraggingProvider.notifier).state = false;
            },
            child: Container(
              height: 10,
              width: double.infinity,
              color: Colors.deepPurple[100],
              child: Center(
                child: Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlsOverlay(WidgetRef ref, FlickManager flickManager, bool isFullscreen) {
    return Consumer(
      builder: (context, ref, child) {
        final isLocked = ref.watch(isLockedVideoProvider);
        
        return ListenableBuilder(
          listenable: flickManager.flickDisplayManager!,
          builder: (context, child) {
            final showControls = flickManager.flickDisplayManager!.showPlayerControls;

            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Standard controls or Lock Blocker
                if (isLocked)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      onTapDown: (_) {},
                      onDoubleTap: () {},
                      onLongPress: () {},
                      onVerticalDragStart: (_) {},
                      onHorizontalDragStart: (_) {},
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  )
                else
                  Positioned.fill(
                    child: isFullscreen ? FlickLandscapeControls() : FlickPortraitControls(),
                  ),

                // 2. Subtitles - Interactive only when locked. ONLY in fullscreen.
                if (isFullscreen && (isLocked || showControls))
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 60, // Avoid overlapping top area (lock button)
                    child: IgnorePointer(
                      ignoring: !isLocked,
                      child: FullScreenPhraseWidget(
                        bottomPadding: isFullscreen ? 60.0 : 20.0,
                      ),
                    ),
                  ),

                // 3. Navigation and Status Buttons
                if (isLocked || showControls || !isFullscreen)
                  Stack(
                    children: [
                      // Back Button - Top Left
                      if (!isLocked)
                        _buildBackButton(
                          context,
                          top: isFullscreen ? 20 : 10,
                          left: isFullscreen ? 30 : 12,
                          size: isFullscreen ? 25 : 22,
                        ),
                      // Lock Button - Top Right
                      _buildLockButton(
                        ref,
                        isLocked,
                        top: isFullscreen ? 20 : 10,
                        right: isFullscreen ? 30 : 12,
                        size: isFullscreen ? 25 : 22,
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBackButton(
    BuildContext context, {
    required double top,
    required double left,
    required double size,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          // Force exit fullscreen if active before popping
          final flickManager = ProviderScope.containerOf(context).read(flickManagerProvider).flickManager;
          if (flickManager?.flickControlManager?.isFullscreen == true) {
            flickManager?.flickControlManager?.exitFullscreen();
          }
          GoRouter.of(context).go('/main');
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }

  Widget _buildLockButton(
      WidgetRef ref,
      bool isLocked, {
        required double top,
        required double right,
        required double size,
      }) {
    return Positioned(
      top: top,
      right: right,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          debugPrint('[LOCK] Toggling lock. Current: $isLocked');
          ref.read(isLockedVideoProvider.notifier).update((state) => !state);
        },
        child: Container(
          padding: const EdgeInsets.all(10), // Increase tap area
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Icon(
            isLocked ? Icons.lock : Icons.lock_open,
            color: isLocked ? Colors.yellowAccent : Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}