import 'dart:io';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

// Провайдери для рисайзу та рухання
final videoHeightProvider = StateProvider<double>((ref) => 250);
final isDraggingProvider = StateProvider<bool>((ref) => false);

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final double? minHeight;
  final double? maxHeight;

  const VideoPlayerWidget({
    super.key,
    this.minHeight = 150,
    this.maxHeight,
  });

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  FlickManager? flickManager;
  late double maxVideoHeight;
  late double minVideoHeight;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenHeight = MediaQuery.of(context).size.height;
    minVideoHeight = widget.minHeight ?? 150;
    maxVideoHeight = widget.maxHeight ?? screenHeight * 0.7;
  }

  Future<void> _init() async {
    final id = ref.read(playerIdProvider.notifier).state;
    final videoObject = await ref
        .read(videoServiceProvider.notifier)
        .getVideoById(id!);

    final controller = VideoPlayerController.file(
      File(videoObject!.videoPath!),
    );

    await controller.initialize();
    await controller.play();
    if (!mounted) {
      controller.dispose();
      return;
    }

    flickManager = FlickManager(
      videoPlayerController: controller,
      autoInitialize: false,
      autoPlay: true, // ← додано: автоматичний запуск після ініціалізації
    );

    controller.addListener(_onControllerUpdate);

    setState(() {});
  }

  void _onControllerUpdate() {
    final controller =
        flickManager?.flickVideoManager?.videoPlayerController;
    if (controller == null) return;

    final position = controller.value.position;
    ref.read(playerTimeProvider.notifier).state = position;
  }

  @override
  void dispose() {
    flickManager?.flickVideoManager?.videoPlayerController
        ?.removeListener(_onControllerUpdate);
    flickManager?.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final currentHeight = ref.read(videoHeightProvider);
    double newHeight = currentHeight + details.delta.dy;

    if (newHeight < minVideoHeight) newHeight = minVideoHeight;
    if (newHeight > maxVideoHeight) newHeight = maxVideoHeight;

    ref.read(videoHeightProvider.notifier).state = newHeight;
  }

  @override
  Widget build(BuildContext context) {
    bool isLocked = ref.watch(isLockedVideoProvider);
    final videoHeight = ref.watch(videoHeightProvider);

    ref.listen<Duration?>(playerSeekProvider, (previous, next) {
      if (next != null) {
        flickManager?.flickControlManager?.seekTo(next);
        Future.microtask(
              () => ref.read(playerSeekProvider.notifier).state = null,
        );
      }
    });

    if (flickManager == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final double videoRatio = flickManager!
        .flickVideoManager!
        .videoPlayerController!
        .value
        .aspectRatio;
    final double aspectRatio = videoRatio > 0 ? videoRatio : 16 / 9;

    return Column(
      children: [
        // Відеоплеєр
        GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragStart: (_) {
            ref.read(isDraggingProvider.notifier).state = true;
          },
          onVerticalDragEnd: (_) {
            ref.read(isDraggingProvider.notifier).state = false;
          },
          child: Container(
            height: videoHeight,
            color: Colors.deepPurpleAccent,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: FlickVideoPlayer(
                flickManager: flickManager!,
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
        ),
        // Розділювач для рисайзу
        MouseRegion(
          cursor: SystemMouseCursors.resizeRow,
          child: GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
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