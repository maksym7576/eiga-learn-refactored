import 'package:eiga/backend/data/dto/AniListDataDTO.dart';
import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';

class AniListEntryCard extends StatelessWidget {
  final AniListDataDTO entry;
  final bool isActive;
  final VoidCallback onTap;

  const AniListEntryCard({
    super.key,
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

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
                      child: _buildCover(theme),
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
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              entry.romajiTitle ?? entry.englishTitle ?? 'Unknown',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
              entry.genres?.isNotEmpty == true ? entry.genres!.join(', ') : 'No genres',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildCover(AdditionalWindowTheme theme) {
    if (entry.coverImageUrl != null) {
      return Image.network(
        entry.coverImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
      );
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
}
