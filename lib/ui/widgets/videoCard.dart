

import 'dart:io';

import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

class VideoCard extends ConsumerWidget {
  final VideoObject video;

  const VideoCard(this.video);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color:  Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
            ref.read(playerIdProvider.notifier).state = video.id;
            context.go('/player');
        },
        borderRadius: BorderRadius.circular(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(child: _buildThumbnail(),
              ),
              Positioned(
                top: 5,
                right: 0,
                  child: PopupMenuButton(
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Text('Modify'),
                              ],
                            ),
                        ),
                        const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Text('Delete'),
                              ],
                            ),
                        ),
                      ],
                    onSelected: (value) {
                        if (value == 'edit') {

                        }
                        if (value == 'delete') {
                            ref.read(videoServiceProvider.notifier).deleteVideoById(video.id);
                        }
                    },
                  ),
              ),
              Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                                  video.videoName ?? 'No name',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent.withOpacity(0.7),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                              ),
                          ),
                          Text(
                            _formatDate(video.createdAt),
                            style: TextStyle(
                              color: Colors.deepPurpleAccent.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                            _LanguageChip(video.originalLanguage ?? ''),
                          const SizedBox(width: 1),
                          Icon(Icons.arrow_forward, color: Colors.deepPurpleAccent.withOpacity(0.7), size: 14),
                          const SizedBox(width: 1),
                          _LanguageChip(video.translatedLanguage ?? ''),
                        ],
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final path = video.thumbnailPath;
    if (path != null && path.isNotEmpty && File(path).existsSync()) {
      return Image.file(File(path), fit: BoxFit.cover, color: Colors.deepPurpleAccent.withOpacity(0.5));
    }
    return Container(
      color: Colors.deepPurpleAccent.withOpacity(0.1),
      child: Align(
        alignment: Alignment(0, -0.3),
        child: Icon(Icons.play_circle_fill, size: 56, color: Colors.deepPurpleAccent.withOpacity(0.7)),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d.$m.$y';
  }

  Widget _LanguageChip(String text) {
    return Center(
      child:
      Chip(
        label: Text(
          text.isEmpty ? '-' : text,
          style: TextStyle(
            color: Colors.deepPurpleAccent.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3) ,
    ),
    );
  }

}