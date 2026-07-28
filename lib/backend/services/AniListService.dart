import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../data/dto/AniListDataDTO.dart';

class AniListService {
  static const _endpoint = 'https://graphql.anilist.co';
  static const _timeout = Duration(seconds: 15);

  static const _query = r'''
    query ($id: Int) {
      Media(id: $id, type: ANIME) {
        id
        title {
          romaji
          english
          native
        }
        description(asHtml: false)
        bannerImage
        genres
        coverImage {
          extraLarge
          large
          color
        }
      }
    }
  ''';

  Future<AniListDataDTO?> getById(
      int anilistId, {
        bool downloadImages = true,
      }) async {
    try {
      final response = await http
          .post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'query': _query,
          'variables': {'id': anilistId},
        }),
      )
          .timeout(_timeout);

      if (response.statusCode == 429) {
        developer.log('AniList rate limit exceeded', name: 'AniListService');
        return null;
      }

      if (response.statusCode != 200) {
        developer.log(
          'AniList request failed: ${response.statusCode}',
          name: 'AniListService',
        );
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final media = decoded['data']?['Media'] as Map<String, dynamic>?;
      if (media == null) return null;

      var dto = AniListDataDTO.fromJson(media);

      if (downloadImages) {
        final results = await Future.wait([
          if (dto.coverImageUrl != null)
            _downloadAndSave(dto.coverImageUrl!, anilistId, suffix: 'cover')
          else
            Future.value(null),
          if (dto.bannerImage != null)
            _downloadAndSave(dto.bannerImage!, anilistId, suffix: 'banner')
          else
            Future.value(null),
        ]);

        final coverPath = results[0];
        final bannerPath = results[1];

        dto = dto.copyWith(
          coverImagePath: coverPath ?? dto.coverImagePath,
          bannerImagePath: bannerPath ?? dto.bannerImagePath,
        );
      }

      return dto;
    } catch (e, st) {
      developer.log(
        'AniList getById failed',
        name: 'AniListService',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<String?> _downloadAndSave(
      String url,
      int anilistId, {
        required String suffix,
      }) async {
    try {
      final extension = _extractExtension(url);
      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${dir.path}/anilist_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final file = File('${imagesDir.path}/${anilistId}_$suffix.$extension');

      if (await file.exists()) {
        return file.path;
      }

      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode != 200) return null;

      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e, st) {
      developer.log(
        'Failed to download image: $url',
        name: 'AniListService',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  String _extractExtension(String url) {
    final path = Uri.parse(url).path;
    final segment = path.split('/').last;
    final dotIndex = segment.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == segment.length - 1) {
      return 'jpg';
    }
    return segment.substring(dotIndex + 1);
  }
}