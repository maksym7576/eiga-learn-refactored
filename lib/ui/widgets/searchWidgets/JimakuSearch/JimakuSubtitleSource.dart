import 'package:eiga/backend/data/dto/JimakuFileOrGroupDTO.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'package:eiga/providers/searchProvider.dart';
import 'package:eiga/ui/widgets/searchWidgets/JimakuSearch/JimakuEntryTile.dart';
import 'package:eiga/ui/widgets/searchWidgets/JimakuSearch/JimakuFileTile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';

import '../../../../backend/services/JimakuService.dart';
import '../../../../providers/servicesProviders.dart';
import '../searchSourceAbstract.dart';

class JimakuSubtitleSource implements SearchSource<JimakuDataDTO, JimakuFileOrGroupDTO> {
  @override
  String get key => SearchSourceKeys.jimaku;

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

  // Track expanded groups and raw files locally
  final Set<String> _expandedGroups = {};
  List<FileJimakuDTO> _rawFilesCache = [];

  Future<JimakuService> _service(WidgetRef ref) {
    return ref.read(jimakuServiceProvider.future);
  }

  @override
  Future<List<JimakuDataDTO>> search(
      String query, Map<String, dynamic> filters, WidgetRef ref) async {
    _expandedGroups.clear(); 
    _rawFilesCache = [];
    final service = await _service(ref);
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
  Future<List<JimakuFileOrGroupDTO>> getFiles(
      JimakuDataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = await _service(ref);
    _rawFilesCache = await service.getFiles(entry.id);
    
    final groups = JimakuClusteringUtil.groupFiles(_rawFilesCache);
    return _flattenGroups(groups);
  }

  void _toggleGroup(String name, WidgetRef ref) {
    if (_expandedGroups.contains(name)) {
      _expandedGroups.remove(name);
    } else {
      _expandedGroups.add(name);
    }
    
    final groups = JimakuClusteringUtil.groupFiles(_rawFilesCache);
    final flattened = _flattenGroups(groups);
    ref.read(filesProvider(key).notifier).state = flattened;
  }

  List<JimakuFileOrGroupDTO> _flattenGroups(List<JimakuGroup> groups) {
    final List<JimakuFileOrGroupDTO> result = [];
    for (var group in groups) {
      final bool isExpanded = _expandedGroups.contains(group.name);
      
      if (group.files.length == 1) {
        result.add(JimakuFileOrGroupDTO(file: group.files.first));
        continue;
      }

      result.add(JimakuFileOrGroupDTO(group: group..isExpanded = isExpanded));
      
      if (isExpanded) {
        for (var file in group.files) {
          result.add(JimakuFileOrGroupDTO(file: file));
        }
      }
    }
    return result;
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    final item = selected as JimakuFileOrGroupDTO;
    if (item.isGroup) throw Exception('Cannot resolve a group');
    
    final file = item.file!;
    final service = await _service(ref);
    return service.downloadAndCacheFile(file.url, preferredName: file.name);
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    // ... existing filter bar logic ...
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
                    selectedColor: Colors.redAccent.withValues(alpha: 0.15),
                    onSelected: (val) => updateFilter('includeAdult', val),
                  ),
                  FilterChip(
                    label: const Text('Unverified'),
                    selected: includeUnverified,
                    showCheckmark: false,
                    avatar: includeUnverified ? const Icon(Icons.warning_amber_rounded, size: 18) : null,
                    selectedColor: Colors.deepPurpleAccent.withValues(alpha: 0.15),
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
  Widget buildFileCard(JimakuFileOrGroupDTO item, bool isActive, VoidCallback onTap) {
    if (item.isGroup) {
      final group = item.group!;
      return Consumer(
        builder: (context, ref, child) {
          return _JimakuGroupTile(
            group: group,
            onTap: () => _toggleGroup(group.name, ref),
          );
        },
      );
    }
    
    // It's a file. 
    final bool isSubItem = _expandedGroups.contains(JimakuClusteringUtil.groupFiles([item.file!]).first.name) 
        || _expandedGroups.any((g) => item.file!.name.contains(g));

    return JimakuFileTile(
      file: item.file!,
      isActive: isActive,
      onTap: onTap,
      isSubItem: isSubItem,
    );
  }

  @override
  String entryId(JimakuDataDTO entry) => entry.id.toString();

  @override
  String fileId(JimakuFileOrGroupDTO item) => item.id;

  @override
  String entryLabel(JimakuDataDTO entry) => entry.displayTitle;
}

class _JimakuGroupTile extends StatelessWidget {
  final JimakuGroup group;
  final VoidCallback onTap;

  const _JimakuGroupTile({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                group.isExpanded ? Icons.folder_open : Icons.folder,
                color: Colors.deepPurpleAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${group.files.length} files',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                group.isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.deepPurpleAccent,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
