

import 'package:hooks_riverpod/hooks_riverpod.dart';


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
