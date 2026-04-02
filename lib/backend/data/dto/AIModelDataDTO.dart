

import 'dart:ui';

import 'package:flutter/material.dart';

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


  Color get usageColor {
    if (maxLimit == 0) return Colors.grey;

    final double usage = used / maxLimit;

    if (usage < 0.7) return Colors.green;
    if (usage < 1.0) return Colors.orange;
    return Colors.red;
  }


}