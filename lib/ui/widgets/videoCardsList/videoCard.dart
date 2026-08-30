import 'dart:io';

import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoCard extends ConsumerWidget {
  final VideoObject video;

  const VideoCard(this.video, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            ref.read(playerIdProvider.notifier).state = video.id;
            context.push('/player');
          },
          borderRadius: BorderRadius.circular(18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Positioned.fill(child: _buildThumbnail(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
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
                                  color: Colors.deepPurpleAccent.withValues(alpha: 0.9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              _formatDate(video.createdAt),
                              style: TextStyle(
                                color: Colors.deepPurpleAccent.withValues(alpha: 0.7),
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
                            Icon(Icons.arrow_forward, color: Colors.deepPurpleAccent.withValues(alpha: 0.7), size: 14),
                            const SizedBox(width: 1),
                            _LanguageChip(video.translatedLanguage ?? ''),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton(
                      icon: const Icon(Icons.more_vert, color: Colors.deepPurpleAccent),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final cover = video.coverImagePath;

    if (cover != null && cover.trim().isNotEmpty) {
      final isUrl = cover.startsWith('http://') || cover.startsWith('https://');

      if (isUrl) {
        return Image.network(
          cover,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Image.network error for $cover: $error');
            return _buildLocalThumbnailOrPlaceholder();
          },
        );
      } else {
        final file = File(cover);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
          );
        } else {
          debugPrint('coverImagePath file not found: $cover');
        }
      }
    }

    return _buildLocalThumbnailOrPlaceholder();
  }

  Widget _buildLocalThumbnailOrPlaceholder() {

    return Container(
      color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
      child: Align(
        alignment: const Alignment(0, -0.3),
        child: Icon(Icons.play_circle_fill, size: 56, color: Colors.deepPurpleAccent.withValues(alpha: 0.7)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.isEmpty ? '-' : text,
        style: TextStyle(
          color: Colors.deepPurpleAccent.withValues(alpha: 0.9),
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

}