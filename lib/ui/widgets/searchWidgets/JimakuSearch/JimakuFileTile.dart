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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isSubItem ? 40 : 12,
        right: 12,
        top: 4,
        bottom: 4,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.deepPurpleAccent.withValues(alpha: 0.08) 
                : Colors.white.withValues(alpha: isSubItem ? 0.5 : 1.0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? Colors.deepPurpleAccent
                  : Colors.black.withValues(alpha: 0.06),
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isActive ? Icons.check_circle_rounded : Icons.description_outlined,
                size: 20,
                color: isActive ? Colors.deepPurpleAccent : const Color(0xFF64748B),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  file.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatSize(file.size),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
