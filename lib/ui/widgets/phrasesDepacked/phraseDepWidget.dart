import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/ui/styles/PhraseDepTheme.dart';
import 'package:flutter/material.dart';

class PhraseDepWidget extends StatefulWidget {
  final PhraseObject phraseObject;

  const PhraseDepWidget({super.key, required this.phraseObject});

  @override
  State<PhraseDepWidget> createState() => _PhraseDepWidgetState();
}

String _formatTime(DateTime? time) {
  if (time == null) return '--:--';
  final h = time.hour;
  final m = time.minute.toString().padLeft(2, '0');
  final s = time.second.toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

class _PhraseDepWidgetState extends State<PhraseDepWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = PhraseDepTheme.of(context);
    final order = widget.phraseObject.phraseOrder;
    final text = widget.phraseObject.originalPhrase ?? '';
    final start = _formatTime(widget.phraseObject.startTime);
    final end = _formatTime(widget.phraseObject.endTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.cardBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 4),
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: theme.badgeBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${order ?? '?'}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: theme.badgeText,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.normalText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: theme.mutedText,
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            start,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: theme.mutedText,
                            ),
                          ),
                          const SizedBox(width: 1),
                          Icon(
                            Icons.arrow_right_alt,
                            size: 11,
                            color: theme.mutedText,
                          ),
                          Text(
                            end,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: theme.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
