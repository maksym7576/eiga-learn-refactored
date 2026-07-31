import 'package:flutter/material.dart';
import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';

class JimakuEntryTile extends StatelessWidget {
  final JimakuDataDTO entry;
  final bool isActive;
  final VoidCallback onTap;

  const JimakuEntryTile({
    super.key,
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  Widget _buildBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.deepPurpleAccent.withValues(alpha: 0.05) 
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? Colors.deepPurpleAccent
                  : Colors.black.withValues(alpha: 0.08),
              width: isActive ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isActive ? 0.08 : 0.03),
                blurRadius: isActive ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.movie_filter_rounded,
                  color: Colors.deepPurpleAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.displayTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        height: 1.2,
                      ),
                    ),
                    if (entry.japaneseName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          entry.japaneseName!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B).withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (entry.isMovie)
                _buildBadge('MOVIE', Colors.orange)
              else if (entry.isAnime)
                _buildBadge('ANIME', Colors.deepPurpleAccent),
            ],
          ),
        ),
      ),
    );
  }
}
