import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend/data/dto/AniListDataDTO.dart';
import '../backend/data/dto/JimakuDataDTO.dart';
import '../backend/services/AniListService.dart';

final aniListServiceProvider = Provider<AniListService>((ref) {
  return AniListService();
});

class AniListNotifier extends AsyncNotifier<AniListDataDTO?> {
  @override
  Future<AniListDataDTO?> build() async {
    return null;
  }

  Future<void> load(int anilistId, {bool downloadImages = false}) async {
    final service = ref.read(aniListServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(
          () => service.getById(anilistId, downloadImages: downloadImages),
    );
  }

  Future<void> refresh(int anilistId) async {
    await load(anilistId, downloadImages: true);
  }

  void clear() {
    state = const AsyncData(null);
  }
}

final aniListProvider = AsyncNotifierProvider<AniListNotifier, AniListDataDTO?>(
  AniListNotifier.new,
);

final jimakuEntryFinalProvider = StateProvider<JimakuDataDTO?>((ref) => null);
final jimakuFileFinalProvider = StateProvider<FileJimakuDTO?>((ref) => null);