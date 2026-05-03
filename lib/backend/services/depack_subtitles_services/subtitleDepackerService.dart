
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/backend/services/depack_subtitles_services/srtParserService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/videoService.dart';
import 'package:eiga/config/depacker/depackerLanguageConfig.dart';

class SubtitleDepackerService {
  final VideoService videoService;
  final PhraseService phraseService;

  SubtitleDepackerService({
    required this.videoService,
    required this.phraseService,
  });

  Future<List<PhraseObject>> parseSrtPreview({required String filePath, required String language,int videoId = 0}) async {

    String fileContent = await _readFile(filePath);

    if (fileContent.isEmpty) return [];

    final config = DepackerLanguageConfigRegistry.getConfig(language);
    return SrtParser(config).parse(fileContent, videoId);
  }

  Future<void> depack(VideoObject videoObject) async {
    if (videoObject.videoPath == null) return;

    final content = await _readFile(videoObject.pathSubtitle!);

    final config = DepackerLanguageConfigRegistry.getConfig(
        videoObject.originalLanguage);
    final phrases = SrtParser(config).parse(content, videoObject.id);

    await phraseService.addPhrasesList(phrases);
  }

  Future<String> _readFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) return '';
    try {
      return await file.readAsString(encoding: utf8);
    } catch (_) {
      try {
        return await file.readAsString(encoding: Encoding.getByName('shift-jis') ?? latin1);
      } catch (e) {
        return '';
      }
    }
}

}