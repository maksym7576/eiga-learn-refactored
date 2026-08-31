import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/AiRequestPhase.dart';
import '../../../providers/aiTrackerProvider.dart';
import '../../../providers/servicesProviders.dart';

class AiRequestStatusWidget extends ConsumerWidget {
  const AiRequestStatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(aiTrackerProvider);
    final theme = AdditionalWindowTheme.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Text(
            'AI Insights',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: theme.titleColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'REQUEST HISTORY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: theme.mutedText.withValues(alpha: 0.6),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),

        if (tracker.history.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.history_rounded, size: 48, color: theme.mutedText.withValues(alpha: 0.15)),
                  const SizedBox(height: 12),
                  Text(
                    'No requests made yet',
                    style: TextStyle(color: theme.mutedText.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tracker.history.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5), indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final entry = tracker.history[index];
              return _HistoryItem(entry: entry);
            },
          ),
        
        const SizedBox(height: 32),
      ],
    );
  }
}

class _HistoryItem extends StatefulWidget {
  final AiRequestEntry entry;

  const _HistoryItem({required this.entry});

  @override
  State<_HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<_HistoryItem> {
  bool _expanded = false;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    if (widget.entry.phase == 'processing') {
      _startTimer();
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || widget.entry.phase != 'processing') return false;
      setState(() {
        _now = DateTime.now();
      });
      return true;
    });
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  String _getElapsed(DateTime start) {
    final diff = _now.difference(start);
    final seconds = diff.inSeconds;
    return "${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final isProcessing = entry.phase == 'processing';
    final isError = entry.phase == 'error';
    final isPartial = entry.phase == 'partialSuccess';
    final scheme = Theme.of(context).colorScheme;
    
    final Color statusColor = isProcessing
        ? scheme.primary
        : (isError 
            ? scheme.error 
            : (isPartial ? Colors.orange.shade700 : Colors.green));
    
    final duration = entry.endTime != null 
        ? entry.endTime!.difference(entry.startTime!)
        : (isProcessing ? _now.difference(entry.startTime!) : null);

    return InkWell(
      onTap: (isError || isPartial) ? () => setState(() => _expanded = !_expanded) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: isProcessing 
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: statusColor),
                      )
                    : Icon(
                        isError ? Icons.error_outline_rounded : (isPartial ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded),
                        color: statusColor, 
                        size: 16
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.requestType ?? 'AI Request',
                        style: TextStyle(
                          fontWeight: FontWeight.w700, 
                          fontSize: 14,
                          color: isPartial ? Colors.orange.shade900 : (isProcessing ? scheme.primary : null),
                        ),
                      ),
                      Text(
                        entry.modelName ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 11, 
                          color: scheme.onSurface.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isProcessing ? 'PROCESSING' : _formatTime(entry.startTime!),
                      style: TextStyle(
                        fontSize: 10, 
                        fontWeight: FontWeight.w900, 
                        color: isProcessing ? scheme.primary : scheme.onSurface.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (duration != null)
                      Text(
                        isProcessing 
                          ? _getElapsed(entry.startTime!)
                          : '${duration.inSeconds}.${(duration.inMilliseconds % 1000) ~/ 100}s',
                        style: TextStyle(
                          fontSize: 10,
                          color: isProcessing ? scheme.primary.withValues(alpha: 0.7) : scheme.onSurface.withValues(alpha: 0.3),
                          fontWeight: isProcessing ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                  ],
                ),
                if (isError || isPartial)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: scheme.onSurface.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
            if (_expanded && (isError || isPartial)) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry.errorMessage != null)
                      Text(
                        entry.errorMessage!,
                        style: TextStyle(fontSize: 12, color: statusColor.withValues(alpha: 0.9), height: 1.4),
                      ),
                    if (entry.failedIds != null && entry.failedIds!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Failed IDs: ${entry.failedIds!.join(', ')}',
                        style: TextStyle(fontSize: 11, color: scheme.onSurface.withValues(alpha: 0.5), fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 8),
                      Consumer(
                        builder: (context, ref, child) {
                          return TextButton.icon(
                            onPressed: () {
                              ref.read(translationProvider).retryPhrases(entry.failedIds!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Retrying failed phrases...')),
                              );
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Retry Failed'),
                            style: TextButton.styleFrom(
                              foregroundColor: statusColor,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              backgroundColor: statusColor.withValues(alpha: 0.1),
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


void showAiRequestResultSnackBar(BuildContext context, AiRequestResult result) {
  if (result.isOk) return;
  final error = result.error;
  if (error == null) return;

  final isWarning = result.phase == AiRequestPhase.partialSuccess;
  final scheme = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isWarning ? Colors.orange.shade800 : scheme.error,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            error.title,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            error.message,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
