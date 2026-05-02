

import 'dart:io';

import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/ui/widgets/videoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoListWidget extends ConsumerStatefulWidget {
  const VideoListWidget({super.key});

  @override
  ConsumerState<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends ConsumerState<VideoListWidget> {

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(videoServiceProvider);

    if (videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("You don't have videos", style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: videos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) => VideoCard(videos[index]),
    );
  }
}