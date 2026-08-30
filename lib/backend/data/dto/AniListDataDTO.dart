class AniListDataDTO {
  final int? id;
  final String? romajiTitle;
  final String? englishTitle;
  final String? nativeTitle;
  final String? coverImagePath;
  final String? coverImageUrl;
  final String? bannerImagePath;
  final String? bannerImage;
  final String? description;
  final List<String>? genres;
  final int? colorThemeValue;

  const AniListDataDTO({
    this.id,
    this.romajiTitle,
    this.englishTitle,
    this.nativeTitle,
    this.coverImagePath,
    this.coverImageUrl,
    this.bannerImagePath,
    this.bannerImage,
    this.description,
    this.genres,
    this.colorThemeValue,
  });

  factory AniListDataDTO.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>? ?? {};
    final cover = json['coverImage'] as Map<String, dynamic>? ?? {};

    int? colorValue;
    final colorStr = cover['color'] as String?;
    if (colorStr != null && colorStr.startsWith('#')) {
      final hex = colorStr.replaceFirst('#', '');
      colorValue = int.tryParse('FF$hex', radix: 16);
    }

    return AniListDataDTO(
      id: json['id'] as int?,
      romajiTitle: title['romaji'] as String?,
      englishTitle: title['english'] as String?,
      nativeTitle: title['native'] as String?,
      coverImageUrl: (cover['extraLarge'] ?? cover['large']) as String?,
      bannerImage: json['bannerImage'] as String?,
      description: json['description'] as String?,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      colorThemeValue: colorValue,
    );
  }

  AniListDataDTO copyWith({
    int? id,
    String? romajiTitle,
    String? englishTitle,
    String? nativeTitle,
    String? coverImagePath,
    String? coverImageUrl,
    String? bannerImagePath,
    String? bannerImage,
    String? description,
    List<String>? genres,
    int? colorThemeValue,
  }) {
    return AniListDataDTO(
      id: id ?? this.id,
      romajiTitle: romajiTitle ?? this.romajiTitle,
      englishTitle: englishTitle ?? this.englishTitle,
      nativeTitle: nativeTitle ?? this.nativeTitle,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      bannerImagePath: bannerImagePath ?? this.bannerImagePath,
      bannerImage: bannerImage ?? this.bannerImage,
      description: description ?? this.description,
      genres: genres ?? this.genres,
      colorThemeValue: colorThemeValue ?? this.colorThemeValue,
    );
  }
}
