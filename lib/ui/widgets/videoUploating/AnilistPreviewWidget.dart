import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/anilistServiceProvider.dart';

class AnilistPreviewWidget extends ConsumerWidget {
  const AnilistPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoadingAnilist = ref.watch(isLoadingAnilistProvider);
    final anilistData = ref.watch(anilistDataProvider);

    if (isLoadingAnilist) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const LinearProgressIndicator(),
        ),
      );
    }

    if (anilistData == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (anilistData.localCoverPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(anilistData.localCoverPath!),
                  width: 40,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                anilistData.displayTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}