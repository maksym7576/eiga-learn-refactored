import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/ui/widgets/videoCardsList/videoCard.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../styles/VideoListTheme.dart';

class VideoListWidget extends ConsumerStatefulWidget {
  const VideoListWidget({super.key});

  @override
  ConsumerState<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends ConsumerState<VideoListWidget> {
  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(videoServiceProvider);
    final theme = VideoListTheme.of(context);

    if (videos.isEmpty) {
      return const _EmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: theme.gridPadding,
      itemCount: videos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: theme.crossAxisSpacing,
        mainAxisSpacing: theme.mainAxisSpacing,
        childAspectRatio: theme.childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoCard(
          key: ValueKey(video.id),
          video,
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = VideoListTheme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.iconContainerColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.video_library_outlined,
              size: 56,
              color: theme.iconColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Still you do not have videos',
            style: theme.emptyStateTitleStyle,
          ),
          const SizedBox(height: 8),
          Text(
            'Add first video',
            textAlign: TextAlign.center,
            style: theme.emptyStateSubtitleStyle,
          ),
        ],
      ),
    );
  }
}