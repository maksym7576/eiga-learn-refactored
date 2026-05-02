

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