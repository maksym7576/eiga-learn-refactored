

import 'package:eiga/providers/servicesProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend/data/models/videoObject.dart';

final playerTimeProvider = StateProvider<Duration>((ref) {
  return Duration.zero;
});

final playerIdProvider = StateProvider<int?>((ref) {
  return null;
});

final isLockedVideoProvider = StateProvider<bool>((ref) {
  return false;
});

final isFullScreenProvider = StateProvider<bool>((ref) {
  return false;
});

final videoDurationProvider = StateProvider<Duration>((ref) {
  return Duration.zero;
});

final autoScrollProvider = StateNotifierProvider<AutoScrollNotifier, bool>(
    (ref) => AutoScrollNotifier(),
);

class AutoScrollNotifier extends StateNotifier<bool> {
  AutoScrollNotifier() : super(true);

  void enable() => state = true;
  void disable() => state = false;
  void toggle() => state = !state;
}

final playerSeekProvider = StateProvider<Duration?>((ref) => null);

final currentVideoProvider = FutureProvider<VideoObject?>((ref) async {
  final videoId = ref.watch(playerIdProvider);

  if (videoId == null) {
    return null;
  }

  final videoService = ref.read(videoServiceProvider.notifier);
  return await videoService.getVideoById(videoId);
});

final videoResearchInfoProvider = Provider<AsyncValue<({bool? isResearchDone, String? researchInformation})?>>((ref) {
  final videoState = ref.watch(currentVideoProvider);

  return videoState.whenData((video) {
    if (video == null) return null;

    return (
    isResearchDone: video.isResearchDone,
    researchInformation: video.researchInformation,
    );
  });
});
