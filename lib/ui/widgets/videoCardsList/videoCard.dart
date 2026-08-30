import 'dart:io';

import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../styles/VideoCardTheme.dart';

class VideoCard extends ConsumerWidget {
  final VideoObject video;

  const VideoCard(this.video, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = VideoCardTheme.of(context);

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: theme.borderRadius,
          color: theme.cardBackground,
          boxShadow: theme.cardShadow,
        ),
        child: InkWell(
          onTap: () async {
            ref.read(playerIdProvider.notifier).state = video.id;
            context.push('/player');
          },
          borderRadius: theme.borderRadius,
          child: ClipRRect(
            borderRadius: theme.borderRadius,
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildThumbnail(theme),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                    decoration: BoxDecoration(
                      color: theme.footerBackground,
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
                                style: theme.titleStyle,
                              ),
                            ),
                            Text(
                              _formatDate(video.createdAt),
                              style: theme.dateStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _LanguageChip(video.originalLanguage ?? '', theme),
                            const SizedBox(width: 1),
                            Icon(Icons.arrow_forward, color: theme.chipIconColor, size: 14),
                            const SizedBox(width: 1),
                            _LanguageChip(video.translatedLanguage ?? '', theme),
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
                      color: theme.footerBackground,
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: theme.menuIconColor),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Modify', style: TextStyle(color: theme.normalText)),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
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

  Widget _buildThumbnail(VideoCardTheme theme) {
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
              color: theme.thumbnailPlaceholderBackground,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Image.network error for $cover: $error');
            return _buildLocalThumbnailOrPlaceholder(theme);
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

    return _buildLocalThumbnailOrPlaceholder(theme);
  }

  Widget _buildLocalThumbnailOrPlaceholder(VideoCardTheme theme) {
    return Container(
      color: theme.thumbnailPlaceholderBackground,
      child: Align(
        alignment: const Alignment(0, -0.3),
        child: Icon(Icons.play_circle_fill, size: 56, color: theme.thumbnailIconColor),
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

  Widget _LanguageChip(String text, VideoCardTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.chipBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.isEmpty ? '-' : text,
        style: theme.chipTextStyle,
      ),
    );
  }
}