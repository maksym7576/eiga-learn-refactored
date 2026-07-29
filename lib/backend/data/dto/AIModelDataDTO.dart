import 'dart:ui';

import 'package:flutter/material.dart';

class AiModelDataDTO {
  final String name;
  final String url;
  final int maxLimit;
  final int used;
  final int phrasesPerRequest;
  final DateTime? lastUpdated;
  final bool isStreamingEnabled;

  AiModelDataDTO({
    required this.name,
    required this.url,
    required this.maxLimit,
    required this.used,
    required this.phrasesPerRequest,
    required this.isStreamingEnabled,
    this.lastUpdated,
  });

  Color get usageColor {
    if (maxLimit == 0) return Colors.grey;

    final double usage = used / maxLimit;

    if (usage < 0.7) return Colors.green;
    if (usage < 1.0) return Colors.orange;
    return Colors.red;
  }

  AiModelDataDTO copyWith({
    String? name,
    String? url,
    int? maxLimit,
    int? used,
    int? phrasesPerRequest,
    DateTime? functionLastUpdated,
    bool? isStreamingEnabled,
  }) {
    return AiModelDataDTO(
      name: name ?? this.name,
      url: url ?? this.url,
      maxLimit: maxLimit ?? this.maxLimit,
      used: used ?? this.used,
      phrasesPerRequest: phrasesPerRequest ?? this.phrasesPerRequest,
      isStreamingEnabled: isStreamingEnabled ?? this.isStreamingEnabled,
    );
  }
}