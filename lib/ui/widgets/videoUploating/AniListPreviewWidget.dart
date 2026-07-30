import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/DTOProviders.dart';

class AnilistPreviewWidget extends ConsumerWidget {
  const AnilistPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(aniListProvider);

    final isLoading = asyncData.isLoading;
    final anilistData = asyncData.value;

    if (isLoading && anilistData == null) {
      return _buildLoading();
    }

    if (anilistData == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildCover(anilistData.coverImagePath),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                anilistData.romajiTitle?.isNotEmpty == true
                    ? anilistData.romajiTitle!
                    : '',
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: const [
            SizedBox(
              width: 40,
              height: 56,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text('Завантаження...', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(String? path) {
    if (path == null || path.isEmpty) {
      return const SizedBox(width: 40, height: 56);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.file(
        File(path),
        width: 40,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 40,
            height: 56,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
          );
        },
      ),
    );
  }
}