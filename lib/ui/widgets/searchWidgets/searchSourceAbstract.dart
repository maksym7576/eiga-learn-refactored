import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class SearchSource<TEntry, TFile> {
  String get key;

  String get title;
  String get searchHint;

  bool get hasFileStage;

  Map<String, dynamic> get defaultFilters;

  Future<List<TEntry>> search(
      String query,
      Map<String, dynamic> filters,
      WidgetRef ref,
      );

  Future<List<TFile>> getFiles(
      TEntry entry,
      Map<String, dynamic> filters,
      WidgetRef ref,
      ) =>
      Future.value(const []);

  Future<String> resolve(dynamic selected, WidgetRef ref);

  Widget buildFilterBar(BuildContext context, WidgetRef ref);

  Widget buildEntryCard(TEntry entry, bool isActive, VoidCallback onTap);

  Widget buildFileCard(TFile file, bool isActive, VoidCallback onTap) =>
      const SizedBox.shrink();

  String entryId(TEntry entry);
  String fileId(TFile file);

  String entryLabel(TEntry entry);
}