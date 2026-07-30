// AiRequestStatusWidget.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../backend/exeption/AiUserFacingError.dart';
import '../../../providers/AiRequestPhase.dart';

final aiRequestResultProvider = StateProvider<AiRequestResult?>((ref) => null);


class AiRequestStatusWidget extends ConsumerWidget {
  const AiRequestStatusWidget({
    super.key,
    this.onAction,
  });

  final void Function(AiRequestResult result)? onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(aiRequestResultProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (result != null && !result.isOk) ...[
          const SizedBox(height: 16),
          const Text(
            'AI Request Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SizeTransition(
              sizeFactor: anim,
              axisAlignment: -1.0,
              child: RepaintBoundary(child: child),
            ),
          ),
          child: (result == null || result.isOk)
              ? const SizedBox.shrink(key: ValueKey('ai-status-empty'))
              : _StatusBanner(
            key: ValueKey('ai-status-${result.phase}'),
            result: result,
            onDismiss: () => ref.read(aiRequestResultProvider.notifier).state = null,
            onAction: onAction == null ? null : () => onAction!(result),
          ),
        ),
        if (result != null && !result.isOk) const SizedBox(height: 20),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    super.key,
    required this.result,
    required this.onDismiss,
    this.onAction,
  });

  final AiRequestResult result;
  final VoidCallback onDismiss;
  final VoidCallback? onAction;

  bool get _isWarning => result.phase == AiRequestPhase.partialSuccess;

  @override
  Widget build(BuildContext context) {
    final AiUserFacingError? error = result.error;
    if (error == null) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final Color accent = _isWarning ? Colors.orange.shade700 : scheme.error;
    final IconData icon = _isWarning ? Icons.warning_amber_rounded : Icons.error_outline_rounded;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  error.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error.instruction,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (result.failedPhraseIds.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'IDs: ${result.failedPhraseIds.join(", ")}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
                if (onAction != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        foregroundColor: accent,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Виправити'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onDismiss,
            tooltip: 'Закрити',
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
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
