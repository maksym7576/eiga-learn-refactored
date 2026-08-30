import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';
import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';

class JimakuFileTile extends StatelessWidget {
  final FileJimakuDTO file;
  final bool isActive;
  final VoidCallback onTap;
  final bool isSubItem;

  const JimakuFileTile({
    super.key,
    required this.file,
    required this.isActive,
    required this.onTap,
    this.isSubItem = false,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()}y ago';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()}mo ago';
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final ext = file.name.split('.').last.toUpperCase();
    
    return Padding(
      padding: EdgeInsets.only(
        left: isSubItem ? 16 : 0,
        right: 0,
        top: 0,
        bottom: isSubItem ? 2 : 0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: isSubItem 
                ? Border(left: BorderSide(color: theme.selectionAccentColor.withValues(alpha: 0.3), width: 2)) 
                : null,
          ),
          padding: EdgeInsets.only(left: isSubItem ? 12 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive 
                  ? theme.selectionAccentColor.withValues(alpha: 0.08) 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? theme.selectionAccentColor : theme.cardBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.description_rounded,
                    size: isSubItem ? 18 : 20,
                    color: isActive ? theme.selectionAccentColor : theme.subtitleColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: TextStyle(
                          fontSize: isSubItem ? 13 : 14,
                          fontWeight: FontWeight.w500,
                          color: theme.normalText,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_formatSize(file.size)} · ${_formatDate(file.lastModified)}',
                        style: TextStyle(
                          fontSize: isSubItem ? 11 : 12,
                          color: theme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.selectionAccentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ext,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: theme.selectionAccentColor,
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

  Widget _buildDetailBadge(IconData icon, String label, AdditionalWindowTheme theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.mutedText.withValues(alpha: 0.6)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: theme.mutedText,
          ),
        ),
      ],
    );
  }
}
