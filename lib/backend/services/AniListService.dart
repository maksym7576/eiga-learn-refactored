import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../data/dto/AnilistDataDTO.dart';

class AnilistService {
  static const _endpoint = 'https://graphql.anilist.co';

  static const _query = r'''
    query ($id: Int) {
      Media(id: $id, type: ANIME) {
        id
        title {
          romaji
          english
        }
        coverImage {
          extraLarge
          large
        }
      }
    }
  ''';

  /// Отримати дані аніме по anilistId. Повертає null, якщо не знайдено / помилка.
  Future<AnilistDataDTO?> getById(int anilistId) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'query': _query,
        'variables': {'id': anilistId},
      }),
    );

    if (response.statusCode != 200) return null;

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final media = decoded['data']?['Media'] as Map<String, dynamic>?;
    if (media == null) return null;

    return AnilistDataDTO.fromJson(media);
  }

  Future<String?> downloadAndSaveCover(String url, int anilistId) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final dir = await getApplicationDocumentsDirectory();
      final coversDir = Directory('${dir.path}/anilist_covers');
      if (!await coversDir.exists()) {
        await coversDir.create(recursive: true);
      }

      final extension = url.split('.').last.split('?').first;
      final file = File('${coversDir.path}/$anilistId.$extension');
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}