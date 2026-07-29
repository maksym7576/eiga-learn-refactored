import 'package:eiga/config/pipeline/translationPeplines/%D1%81ontextTranslationPipeline.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/servicesProviders.dart';
import '../../../providers/videoDataProviders.dart';
import 'PipelineAbstract.dart';
import 'PipelineStepType.dart';
import 'TotalPipeline.dart';

class PipelineManager {
  static final Map<String, PipelineAbstract> _registry = {
    'context_translation_v1': ContextTranslationPipeline(),
    'total_v1': TotalPipeline(),
  };

  static PipelineAbstract? byId(String id) => _registry[id];

  static Future<PipelineBuildResult?> buildForCurrentVideo(
      Ref ref, {
        String? pipelineId,
      }) async {
    final playerId = ref.read(playerIdProvider);
    if (playerId == null) return null;

    final video = await ref
        .read(videoServiceProvider.notifier)
        .getVideoById(playerId);
    if (video == null) return null;

    final resolvedId = pipelineId ?? video.pepelineIndetificator;
    if (resolvedId == null) return null;

    final pipeline = byId(resolvedId);
    if (pipeline == null) return null;

    return await pipeline.build(video);
  }
}