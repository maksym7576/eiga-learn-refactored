import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhraseDepWidget extends StatefulWidget {
  final PhraseObject phraseObject;

  PhraseDepWidget({super.key, required this.phraseObject});

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
    final order = widget.phraseObject.phraseOrder;
    final text = widget.phraseObject.originalPhrase ?? '';
    final start = _formatTime(widget.phraseObject.startTime);
    final end = _formatTime(widget.phraseObject.endTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.deepPurple.withOpacity(0.1),
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 4),
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${order ?? '?'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.deepPurpleAccent,
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: Colors.deepPurple.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            '$start',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurple.withOpacity(0.4),
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          SizedBox(width: 1),
                          Icon(
                            Icons.arrow_right_alt,
                            size: 11,
                            color: Colors.deepPurple.withOpacity(0.4),
                          ),
                          Text(
                            '$end',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurple.withOpacity(0.4),
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
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
