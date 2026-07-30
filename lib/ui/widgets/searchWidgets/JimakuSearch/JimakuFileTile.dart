import 'package:flutter/material.dart';
import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';

class JimakuFileTile extends StatelessWidget {
  final FileJimakuDTO file;
  final bool isActive;
  final VoidCallback onTap;

  const JimakuFileTile({
    super.key,
    required this.file,
    required this.isActive,
    required this.onTap,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
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
              color: isActive
                  ? Colors.deepPurpleAccent
                  : Colors.deepPurpleAccent.withValues(alpha: 0.3),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.subtitles,
                  size: 18, color: Colors.deepPurpleAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  file.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _formatSize(file.size),
                style:
                TextStyle(fontSize: 11, color: Colors.black.withValues(alpha: 0.4)),
              ),
              if (isActive)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check_circle,
                      color: Colors.deepPurpleAccent, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}