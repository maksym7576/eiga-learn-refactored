import 'package:eiga/backend/data/dto/AniListDataDTO.dart';
import 'package:eiga/providers/DTOProviders.dart';
import 'package:eiga/providers/searchProvider.dart';
import 'package:eiga/ui/widgets/searchWidgets/searchSourceAbstract.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'AniListEntryCard.dart';

class AniListSearchSource implements SearchSource<AniListDataDTO, void> {
  @override
  String get key => SearchSourceKeys.anilist;

  @override
  String get title => 'AniList Search';

  @override
  String get searchHint => 'Search for an anime...';

  @override
  bool get hasFileStage => false;

  @override
  Map<String, dynamic> get defaultFilters => {};

  @override
  Future<List<AniListDataDTO>> search(
      String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = ref.read(aniListServiceProvider);
    return await service.getByName(query);
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    final entry = selected as AniListDataDTO;
    // For AniList, "resolving" might mean ensuring we have full data and refreshing the global provider
    if (entry.id != null) {
      await ref.read(aniListProvider.notifier).refresh(entry.id!);
    }
    return entry.id.toString();
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildEntryCard(AniListDataDTO entry, bool isActive, VoidCallback onTap) {
    return AniListEntryCard(
      entry: entry,
      isActive: isActive,
      onTap: onTap,
    );
  }

  @override
  Future<List<void>> getFiles(
      AniListDataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    return [];
  }

  @override
  Widget buildFileCard(void file, bool isActive, VoidCallback onTap) {
    return const SizedBox.shrink();
  }

  @override
  String entryId(AniListDataDTO entry) => entry.id.toString();

  @override
  String fileId(void file) => '';

  @override
  String entryLabel(AniListDataDTO entry) => 
      entry.romajiTitle ?? entry.englishTitle ?? 'Unknown';
}
