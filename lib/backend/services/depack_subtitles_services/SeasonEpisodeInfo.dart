class SeasonEpisodeInfo {
  final String? season;
  final String? episode;

  const SeasonEpisodeInfo({this.season, this.episode});
}

SeasonEpisodeInfo parseSeasonEpisode(String fileName) {
  final seMatch = RegExp(r'[Ss](\d{1,2})[Ee](\d{1,3})').firstMatch(fileName);
  if (seMatch != null) {
    return SeasonEpisodeInfo(
      season: seMatch.group(1),
      episode: seMatch.group(2),
    );
  }

  final eOnlyMatch = RegExp(r'[-\s]E(\d{1,3})[-\s]').firstMatch(fileName);
  if (eOnlyMatch != null) {
    return SeasonEpisodeInfo(episode: eOnlyMatch.group(1));
  }

  final dashNumMatch = RegExp(r'-\s*(\d{1,3})\s*[\[\(]').firstMatch(fileName);
  if (dashNumMatch != null) {
    return SeasonEpisodeInfo(episode: dashNumMatch.group(1));
  }

  final dashNumEndMatch = RegExp(r'-\s*(\d{1,3})\b').firstMatch(fileName);
  if (dashNumEndMatch != null) {
    return SeasonEpisodeInfo(episode: dashNumEndMatch.group(1));
  }

  return const SeasonEpisodeInfo();
}