

import 'package:hooks_riverpod/hooks_riverpod.dart';

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