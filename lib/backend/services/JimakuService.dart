import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../config/secureStorage.dart';

class JimakuService {
  static const String baseUrl = 'https://jimaku.cc/api';

  final String apiKey;

  JimakuService._(this.apiKey);

  static Future<JimakuService> create() async {
    final token = await SecureTokenStorage.getToken(ApiTokenType.jimaku);

    if (token == null || token.isEmpty) {
      throw Exception('Jimaku API token not found');
    }
    return JimakuService._(token);
  }

  Map<String, String> get headers => {
    'Authorization': apiKey,
    'Content-Type': 'application/json',
  };

  Future<List<JimakuDataDTO>> searchJumakuObjects({
    String? query,
    bool anime = true,
    int? anilistId,
    String? tmdbId,
    int? after,
    int? before,
  }) async {
    final Map<String, String> params = {'anime': anime.toString()};

    if (query != null && query.isNotEmpty) {
      params['query'] = query;
    }
    if (anilistId != null) {
      params['anilist_id'] = anilistId.toString();
    }
    if (tmdbId != null && tmdbId.isNotEmpty) {
      params['tmdb_id'] = tmdbId;
    }
    if (after != null) {
      params['after'] = after.toString();
    }
    if (before != null) {
      params['before'] = before.toString();
    }

    final uri = Uri.parse(
      '$baseUrl/entries/search',
    ).replace(queryParameters: params);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => JimakuDataDTO.fromJson(item)).toList();
    } else {
      throw Exception(
        'Searching error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<FileJimakuDTO>> getFiles(int id, {int? episode}) async {
    final Map<String, String> queryParams = {};
    if (episode != null) {
      queryParams['episode'] = episode.toString();
    }
    final uri = Uri.parse(
      '$baseUrl/entries/$id/files',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => FileJimakuDTO.fromJson(item)).toList();
    } else {
      throw Exception(
        'Error to get files: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<String> downloadAndCacheFile(
    String url, {
    String? preferredName,
    Duration maxAge = const Duration(hours: 1),
  }) async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = Directory(p.join(tempDir.path, 'jimaku_cache'));

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    await _clean01dCache(cacheDir, maxAge);

    final fileName =
        preferredName ??
        '${DateTime.now().microsecondsSinceEpoch}_${p.basename(url)}';

    final localPath = p.join(cacheDir.path, fileName);
    final file = File(localPath);

    if (await file.exists()) {
      final stat = await file.stat();
      if (DateTime.now().difference(stat.modified) < maxAge) {
        return localPath;
      }
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
    await file.writeAsBytes(response.bodyBytes);

    return localPath;
  }

  Future<void> _clean01dCache(Directory dir, Duration maxAge) async {
    try {
      final now = DateTime.now();
      await for (final entry in dir.list()) {
        if (entry is File) {
          final stat = await entry.stat();
          if (now.difference(stat.modified) > maxAge) {
            await entry.delete();
          }
        }
      }
    } catch (_) {}
  }

  Future<void> clearCache() async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = Directory(p.join(tempDir.path, 'jimaku_cache'));
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }
}
