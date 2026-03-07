

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final phraseListProvider = StreamProvider.family<List<PhraseObject>, int>((ref, videoId) {
  final service = ref.watch(phraseServiceProvider);
  return service.watchPhrasesByVideoId(videoId).map((phrases) {
    final sortedList = List<PhraseObject>.from(phrases);
    sortedList.sort((a, b) => (a.phraseOrder ?? 0).compareTo(b.phraseOrder ?? 0));
    return sortedList;
  });
});