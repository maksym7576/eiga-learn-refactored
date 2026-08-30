import 'package:eiga/providers/searchProvider.dart';
import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';
import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../backend/data/dto/AniListDataDTO.dart';

class JimakuEntryCard extends ConsumerWidget {
  final JimakuDataDTO entry;
  final bool isActive;
  final VoidCallback onTap;

  const JimakuEntryCard({
    super.key,
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final metadata = ref.watch(searchMetadataProvider(SearchSourceKeys.jimaku));
    final aniListData = entry.anilistId != null ? metadata[entry.anilistId] as AniListDataDTO? : null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? theme.selectedCardBorder : theme.cardBorder,
                  width: isActive ? 2 : 1,
                ),
                color: theme.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isActive ? 0.08 : 0.03),
                    blurRadius: isActive ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isActive ? 10 : 11),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _buildCover(theme, aniListData),
                    ),
                    if (isActive)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.selectionAccentColor.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                    if (isActive)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.selectionAccentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.check, color: theme.activeTabText, size: 16),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: _buildTypeBadge(context, entry),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              entry.displayTitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                color: theme.normalText,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              entry.japaneseName ?? '',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: theme.mutedText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover(AdditionalWindowTheme theme, AniListDataDTO? aniListData) {
    final hasAnilistId = entry.anilistId != null;
    
    if (aniListData?.coverImageUrl != null) {
      return Image.network(
        aniListData!.coverImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
      );
    }
    
    if (hasAnilistId && aniListData == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    
    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(AdditionalWindowTheme theme) {
    return Center(
      child: Icon(
        Icons.movie_filter_rounded,
        color: theme.mutedText,
        size: 32,
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, JimakuDataDTO entry) {
    final theme = AdditionalWindowTheme.of(context);
    final isMovie = entry.isMovie;
    final color = isMovie ? Colors.orange : theme.primaryAccent;
    final label = isMovie ? 'MOVIE' : 'ANIME';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
