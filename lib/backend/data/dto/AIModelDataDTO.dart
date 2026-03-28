

class AiModelDataDTO {
  final String name;
  final String url;
  final int maxLimit;
  final int used;
  final DateTime? lastUpdated;

  AiModelDataDTO({
    required this.name,
    required this.url,
    required this.maxLimit,
    required this.used,
    this.lastUpdated,
});
}