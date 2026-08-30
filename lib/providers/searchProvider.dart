import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/data/dto/AniListDataDTO.dart';
import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import 'package:eiga/backend/data/dto/JimakuFileOrGroupDTO.dart';

class SearchSourceKeys {
  static const String jimaku = 'jimaku';
  static const String anilist = 'anilist';
}


final searchResultsProvider =
StateProvider.family<List<dynamic>, String>((ref, key) => []);

final selectedEntryProvider =
StateProvider.family<dynamic, String>((ref, key) => null);

final filesProvider =
StateProvider.family<List<dynamic>, String>((ref, key) => []);

final selectedResultProvider =
StateProvider.family<dynamic, String>((ref, key) => null);

final searchFiltersProvider =
StateProvider.family<Map<String, dynamic>, String>((ref, key) => {});

final isSearchingProvider =
StateProvider.family<bool, String>((ref, key) => false);

final isLoadingFilesProvider =
StateProvider.family<bool, String>((ref, key) => false);

final isResolvingProvider =
StateProvider.family<bool, String>((ref, key) => false);

final searchMetadataProvider =
StateProvider.family<Map<int, dynamic>, String>((ref, key) => {});


extension JimakuProviders on WidgetRef {
  List<JimakuDataDTO> watchJimakuResults() => watch(
    searchResultsProvider(SearchSourceKeys.jimaku),
  ).cast<JimakuDataDTO>();

  JimakuDataDTO? watchJimakuSelectedEntry() =>
      watch(selectedEntryProvider(SearchSourceKeys.jimaku)) as JimakuDataDTO?;

  List<JimakuFileOrGroupDTO> watchJimakuFiles() => watch(
    filesProvider(SearchSourceKeys.jimaku),
  ).cast<JimakuFileOrGroupDTO>();

  JimakuFileOrGroupDTO? watchJimakuSelectedResult() =>
      watch(selectedResultProvider(SearchSourceKeys.jimaku)) as JimakuFileOrGroupDTO?;
}

extension AniListSearchProviders on WidgetRef {
  List<AniListDataDTO> watchAniListResults() => watch(
    searchResultsProvider(SearchSourceKeys.anilist),
  ).cast<AniListDataDTO>();

  AniListDataDTO? watchAniListSelectedEntry() =>
      watch(selectedEntryProvider(SearchSourceKeys.anilist)) as AniListDataDTO?;
}
