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

  Widget _buildBadge(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorButtonBorder = isActive
        ? Colors.deepPurpleAccent
        : Colors.deepPurpleAccent.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorButtonBorder,
              width: isActive ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.displayTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    if (entry.japaneseName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          entry.japaneseName!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (entry.isMovie)
                _buildBadge('Movie')
              else if (entry.isAnime)
                _buildBadge('Anime'),
              // if (isActive)
              //   const Padding(
              //     padding: EdgeInsets.only(left: 8),
              //     child: Icon(Icons.check_circle,
              //         color: Colors.deepPurpleAccent, size: 20),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}