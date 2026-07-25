class JimakuDataDTO {
  final int id;
  final String name;
  final String? englishName;
  final String? japaneseName;
  final int? anilistId;
  final String? tmdbId;
  final DateTime lastModified;
  final bool isAnime;
  final bool isMovie;
  final bool isAdult;
  final bool isUnverified;

  JimakuDataDTO({
    required this.id,
    required this.name,
    this.englishName,
    this.japaneseName,
    this.anilistId,
    this.tmdbId,
    required this.lastModified,
    this.isAnime = false,
    this.isMovie = false,
    this.isAdult = false,
    this.isUnverified = false,
  });

  factory JimakuDataDTO.fromJson(Map<String, dynamic> json) {
    final flags = json['flags'] as Map<String, dynamic>? ?? {};

    return JimakuDataDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      englishName: json['english_name'] as String?,
      japaneseName: json['japanese_name'] as String?,
      anilistId: json['anilist_id'] as int?,
      tmdbId: json['tmdb_id'] as String?,
      lastModified: DateTime.parse(json['last_modified'] as String),
      isAnime: flags['anime'] as bool? ?? false,
      isMovie: flags['movie'] as bool? ?? false,
      isAdult: flags['adult'] as bool? ?? false,
      isUnverified: flags['unverified'] as bool? ?? false,
    );
  }

  String get displayTitle => englishName ?? name;
}

class FileJimakuDTO {
  final String name;
  final String url;
  final int size;
  final DateTime lastModified;

  FileJimakuDTO({
    required this.name,
    required this.url,
    required this.size,
    required this.lastModified,
  });

  factory FileJimakuDTO.fromJson(Map<String, dynamic> json) {
    return FileJimakuDTO(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      lastModified: DateTime.parse(json['last_modified'] as String),
    );
  }
}