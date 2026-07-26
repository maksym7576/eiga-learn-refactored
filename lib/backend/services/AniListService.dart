import 'dart:convert';
import 'package:http/http.dart' as http;

class AniListService {
  static const String baseUrl = 'https://graphql.anilist.co';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String _mediaQuery = r'''
    query ($id: Int) {
      Media (id: $id, type: ANIME) {
        title {
          romaji
          english
          native
        }
        coverImage {
          large
          medium
        }
      }
    }
  ''';

  Future<AniListMediaDTO> getTitleAndCover(int anilistId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: json.encode({
        'query': _mediaQuery,
        'variables': {'id': anilistId},
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (decoded.containsKey('errors')) {
        throw Exception('AniList error: ${decoded['errors']}');
      }

      final media = decoded['data']['Media'] as Map<String, dynamic>;
      return AniListMediaDTO.fromJson(media);
    } else {
      throw Exception(
        'Error fetching AniList data: ${response.statusCode} - ${response.body}',
      );
    }
  }
}

class AniListMediaDTO {
  final String title;
  final String coverImageUrl;

  AniListMediaDTO({required this.title, required this.coverImageUrl});

  factory AniListMediaDTO.fromJson(Map<String, dynamic> json) {
    final titleMap = json['title'] as Map<String, dynamic>;
    final cover = json['coverImage'] as Map<String, dynamic>;

    return AniListMediaDTO(
      title: titleMap['english'] ?? titleMap['romaji'] ?? titleMap['native'] ?? '',
      coverImageUrl: cover['large'] ?? cover['medium'] ?? '',
    );
  }
}