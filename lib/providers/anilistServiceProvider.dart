import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend/data/dto/AnilistDataDTO.dart';
import '../backend/services/AniListService.dart';


final anilistServiceProvider = Provider<AnilistService>((ref) => AnilistService());
final anilistDataProvider = StateProvider<AnilistDataDTO?>((ref) => null);

final isLoadingAnilistProvider = StateProvider<bool>((ref) => false);

extension AnilistProviders on WidgetRef {
  Future<void> fetchAnilistMetadata(int anilistId) async {
    read(isLoadingAnilistProvider.notifier).state = true;
    try {
      final service = read(anilistServiceProvider);
      final data = await service.getById(anilistId);
      if (data == null) {
        read(anilistDataProvider.notifier).state = null;
        return;
      }

      String? localCoverPath;
      if (data.coverImageUrl != null) {
        localCoverPath = await service.downloadAndSaveCover(data.coverImageUrl!, anilistId);
      }

      read(anilistDataProvider.notifier).state = data.copyWith(localCoverPath: localCoverPath);
    } finally {
      read(isLoadingAnilistProvider.notifier).state = false;
    }
  }

  void clearAnilistData() {
    read(anilistDataProvider.notifier).state = null;
  }
}