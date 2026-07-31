import 'dart:io';

import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

/// Стан плеєра, що живе окремо від UI-дерева.
class FlickManagerState {
  final FlickManager? flickManager;
  final bool isLoading;
  final Object? error;

  const FlickManagerState({
    this.flickManager,
    this.isLoading = true,
    this.error,
  });

  FlickManagerState copyWith({
    FlickManager? flickManager,
    bool? isLoading,
    Object? error,
  }) {
    return FlickManagerState(
      flickManager: flickManager ?? this.flickManager,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FlickManagerNotifier extends StateNotifier<FlickManagerState> {
  final Ref ref;

  FlickManagerNotifier(this.ref) : super(const FlickManagerState(isLoading: true)) {
    debugPrint('[VP_LIFECYCLE] FlickManagerNotifier created | hash=$hashCode');
    _init();
  }

  Future<void> _init() async {
    try {
      final id = ref.read(playerIdProvider.notifier).state;
      final videoObject = await ref
          .read(videoServiceProvider.notifier)
          .getVideoById(id!);

      final controller = VideoPlayerController.file(
        File(videoObject!.videoPath!),
      );

      await controller.initialize();
      await controller.play();

      final manager = FlickManager(
        videoPlayerController: controller,
        autoInitialize: false,
        autoPlay: true,
      );

      controller.addListener(_onControllerUpdate);
      manager.flickControlManager?.addListener(_onControlUpdate);

      state = state.copyWith(flickManager: manager, isLoading: false);
      debugPrint('[VP_LIFECYCLE] FlickManager initialized | hash=$hashCode | manager=${manager.hashCode}');
    } catch (e, st) {
      debugPrint('[VP_LIFECYCLE] FlickManager init error: $e\n$st');
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void _onControllerUpdate() {
    final controller = state.flickManager?.flickVideoManager?.videoPlayerController;
    if (controller == null) return;
    final position = controller.value.position;
    ref.read(playerTimeProvider.notifier).state = position;
  }

  void _onControlUpdate() {
    final isFullscreen = state.flickManager?.flickControlManager?.isFullscreen ?? false;
    if (ref.read(isFullScreenProvider) != isFullscreen) {
      ref.read(isFullScreenProvider.notifier).state = isFullscreen;
      debugPrint('[VP_LIFECYCLE] Fullscreen changed: $isFullscreen');
    }
  }

  @override
  void dispose() {
    debugPrint('[VP_LIFECYCLE] FlickManagerNotifier dispose | hash=$hashCode');
    state.flickManager?.flickVideoManager?.videoPlayerController
        ?.removeListener(_onControllerUpdate);
    state.flickManager?.flickControlManager?.removeListener(_onControlUpdate);
    state.flickManager?.dispose();
    super.dispose();
  }
}

/// autoDispose: провайдер живе поки на нього хтось підписаний
/// (portrait АБО landscape widget), і Riverpod не знищить його
/// в момент переходу між ними в межах одного build-циклу.
final flickManagerProvider =
StateNotifierProvider.autoDispose<FlickManagerNotifier, FlickManagerState>(
      (ref) {
    debugPrint('[VP_LIFECYCLE] flickManagerProvider created');
    ref.onDispose(() => debugPrint('[VP_LIFECYCLE] flickManagerProvider disposed'));
    return FlickManagerNotifier(ref);
  },
);