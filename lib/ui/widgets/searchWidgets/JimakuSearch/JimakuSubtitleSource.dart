import 'package:eiga/providers/searchProvider.dart';
import 'package:eiga/ui/widgets/searchWidgets/JimakuSearch/JimakuEntryTile.dart';
import 'package:eiga/ui/widgets/searchWidgets/JimakuSearch/JimakuFileTile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import 'package:eiga/backend/services/jimakuService.dart';

import '../searchSourceAbstract.dart';

class JimakuSubtitleSource implements SearchSource<JimakuDataDTO, FileJimakuDTO> {
  @override
  String get key => 'jimaku';

  @override
  String get title => 'Subtitles (Jimaku)';

  @override
  String get searchHint => 'Search anime or movie...';

  @override
  bool get hasFileStage => true;

  @override
  Map<String, dynamic> get defaultFilters => {
    'animeOnly': true,
    'includeAdult': false,
    'includeUnverified': true,
  };

  @override
  Future<List<JimakuDataDTO>> search(
      String query, Map<String, dynamic> filters) async {
    final service = await JimakuService.create();
    final results = await service.searchJumakuObjects(
      query: query,
      anime: filters['animeOnly'] as bool? ?? true,
    );

    final includeAdult = filters['includeAdult'] as bool? ?? false;
    final includeUnverified = filters['includeUnverified'] as bool? ?? true;

    return results.where((e) {
      if (!includeAdult && e.isAdult) return false;
      if (!includeUnverified && e.isUnverified) return false;
      return true;
    }).toList();
  }

  @override
  Future<List<FileJimakuDTO>> getFiles(
      JimakuDataDTO entry, Map<String, dynamic> filters) async {
    final service = await JimakuService.create();
    return service.getFiles(entry.id);
  }

  @override
  Future<String> resolve(dynamic selected) async {
    final file = selected as FileJimakuDTO;
    final service = await JimakuService.create();
    return service.downloadAndCacheFile(file.url, preferredName: file.name);
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider(key));
    final animeOnly = filters['animeOnly'] as bool? ?? true;
    final includeAdult = filters['includeAdult'] as bool? ?? false;
    final includeUnverified = filters['includeUnverified'] as bool? ?? true;

    void updateFilter(String field, dynamic val) {
      ref.read(searchFiltersProvider(key).notifier).state = {
        ...filters,
        field: val,
      };
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: const Icon(Icons.tune),
        title: const Text('Filters', style: TextStyle(fontWeight: FontWeight.w500)),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Anime'),
                    icon: Icon(Icons.animation),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Movie / TV'),
                    icon: Icon(Icons.movie_outlined),
                  ),
                ],
                selected: {animeOnly},
                onSelectionChanged: (Set<bool> newSelection) {
                  updateFilter('animeOnly', newSelection.first);
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: const Text('Adult (18+)'),
                    selected: includeAdult,
                    showCheckmark: false,
                    avatar: includeAdult ? const Icon(Icons.explicit, size: 18) : null,
                    selectedColor: Colors.redAccent.withOpacity(0.15),
                    onSelected: (val) => updateFilter('includeAdult', val),
                  ),
                  FilterChip(
                    label: const Text('Unverified'),
                    selected: includeUnverified,
                    showCheckmark: false,
                    avatar: includeUnverified ? const Icon(Icons.warning_amber_rounded, size: 18) : null,
                    selectedColor: Colors.deepPurpleAccent.withOpacity(0.15),
                    onSelected: (val) => updateFilter('includeUnverified', val),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildEntryCard(JimakuDataDTO entry, bool isActive, VoidCallback onTap) {
    return JimakuEntryTile(entry: entry, isActive: isActive, onTap: onTap);
  }

  @override
  Widget buildFileCard(FileJimakuDTO file, bool isActive, VoidCallback onTap) {
    return JimakuFileTile(file: file, isActive: isActive, onTap: onTap);
  }

  @override
  String entryId(JimakuDataDTO entry) => entry.id.toString();

  @override
  String fileId(FileJimakuDTO file) => file.url;

  @override
  String entryLabel(JimakuDataDTO entry) => entry.displayTitle;
}