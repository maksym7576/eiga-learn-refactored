class AnilistDataDTO {
  final int id;
  final String? romajiTitle;
  final String? englishTitle;
  final String? coverImageUrl;
  final String? localCoverPath;

  const AnilistDataDTO({
    required this.id,
    this.romajiTitle,
    this.englishTitle,
    this.coverImageUrl,
    this.localCoverPath,
  });

  factory AnilistDataDTO.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>? ?? {};
    final coverImage = json['coverImage'] as Map<String, dynamic>? ?? {};

    return AnilistDataDTO(
      id: json['id'] as int,
      romajiTitle: title['romaji'] as String?,
      englishTitle: title['english'] as String?,
      coverImageUrl: (coverImage['extraLarge'] ?? coverImage['large']) as String?,
    );
  }

  AnilistDataDTO copyWith({String? localCoverPath}) => AnilistDataDTO(
    id: id,
    romajiTitle: romajiTitle,
    englishTitle: englishTitle,
    coverImageUrl: coverImageUrl,
    localCoverPath: localCoverPath ?? this.localCoverPath,
  );

  String get displayTitle => englishTitle ?? romajiTitle ?? '';
}