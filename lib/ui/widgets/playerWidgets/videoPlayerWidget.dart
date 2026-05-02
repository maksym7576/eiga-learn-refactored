import 'dart:io';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {

  const VideoPlayerWidget({super.key});

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final id = ref.read(playerIdProvider.notifier).state;
    final videoObject = await ref.read(videoServiceProvider.notifier).getVideoById(id!);
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(videoObject!.videoPath!)),
    );
    setState(() {});
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLocked = ref.watch(isLockedVideoProvider);
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: Stack(
          children: [
            FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                controls: Stack(
                  children: [
                    if (!isLocked) FlickPortraitControls(),
                    _buildLockButton(ref, isLocked, top: 10, right: 12, size: 12),
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
                        _buildLockButton(ref, isLocked, top: 10, right: 30, size: 25)
                      ],
                    );
                  }
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockButton(WidgetRef ref, bool isLocked, {required double top, required double right, required double size}) {
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
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              isLocked ? Icons.lock : Icons.lock_open,
              color: Colors.white,
              size: size,
            ),
          ),
        )
    );
  }
}
