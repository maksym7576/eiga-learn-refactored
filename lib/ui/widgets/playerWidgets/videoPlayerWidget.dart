import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Стабільний ключ, який зберігається однаковим і в portrait, і в
  // landscape гілці дерева — це додатковий страхувальний трос, щоб
  // Flutter не сприймав це як два різних елементи при зміні orientation.
  static const _stableKey = ValueKey('video_player_widget_stable');

  VideoPlayerWidget({
    this.minHeight = 150,
    this.maxHeight,
    this.isLandscapeSplit = false,
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
    final isFullscreen = ref.watch(isFullScreenProvider);

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
            // Дозволяємо системний автоповорот, коли не в повноекранному режимі
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
              controls: Stack(
                children: [
                  if (!isLocked) FlickPortraitControls(),
                  _buildLockButton(
                    ref,
                    isLocked,
                    top: 10,
                    right: 12,
                    size: 12,
                  ),
                ],
              ),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              videoFit: BoxFit.contain,
              controls: Consumer(
                builder: (context, ref, child) {
                  final isLocked = ref.watch(isLockedVideoProvider);
                  return Stack(
                    children: [
                      if (!isLocked) const FlickLandscapeControls(),
                      _buildLockButton(
                        ref,
                        isLocked,
                        top: 10,
                        right: 30,
                        size: 25,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    if (isLandscapeSplit) {
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
        behavior: HitTestBehavior.translucent,
        onTap: () {
          ref.read(isLockedVideoProvider.notifier).update((state) => !state);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            isLocked ? Icons.lock : Icons.lock_open,
            color: Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}