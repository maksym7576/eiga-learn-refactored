import 'package:eiga/backend/services/aniListService.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend/services/MediaStorageService.dart';

// Чи використовувати AniList замість ручного вводу назви
final useAniListProvider = StateProvider<bool>((ref) => false);

// Сервіс (без стану, тому просто Provider)
final aniListServiceProvider = Provider<AniListService>((ref) {
  return AniListService();
});

// Дані, отримані з AniList для поточної форми завантаження
class AniListFetchState {
  final int? anilistId;
  final String? title;
  final String? coverImagePath; // локальний шлях після збереження
  final bool isLoading;
  final String? error;

  const AniListFetchState({
    this.anilistId,
    this.title,
    this.coverImagePath,
    this.isLoading = false,
    this.error,
  });

  AniListFetchState copyWith({
    int? anilistId,
    String? title,
    String? coverImagePath,
    bool? isLoading,
    String? error,
  }) {
    return AniListFetchState(
      anilistId: anilistId ?? this.anilistId,
      title: title ?? this.title,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AniListFetchNotifier extends StateNotifier<AniListFetchState> {
  final AniListService _service;

  AniListFetchNotifier(this._service) : super(const AniListFetchState());

  Future<void> fetchById(int anilistId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final media = await AniListService.getTitleAndCover(anilistId);
      final localCoverPath = await MediaStorageService.saveCoverImage(
        media.coverImageUrl,
        anilistId,
      );

      state = AniListFetchState(
        anilistId: anilistId,
        title: media.title,
        coverImagePath: localCoverPath,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() {
    state = const AniListFetchState();
  }
}

final aniListFetchProvider =
StateNotifierProvider<AniListFetchNotifier, AniListFetchState>((ref) {
  final service = ref.read(aniListServiceProvider);
  return AniListFetchNotifier(service);
});