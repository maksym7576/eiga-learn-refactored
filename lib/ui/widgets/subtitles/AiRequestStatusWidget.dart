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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) => SizeTransition(
        sizeFactor: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: (result == null || result.isOk)
          ? const SizedBox.shrink(key: ValueKey('ai-status-empty'))
          : _StatusBanner(
        key: ValueKey('ai-status-${result.phase}'),
        result: result,
        onDismiss: () => ref.read(aiRequestResultProvider.notifier).state = null,
        onAction: onAction == null ? null : () => onAction!(result),
      ),
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
        color: accent.withOpacity(0.10),
        border: Border.all(color: accent.withOpacity(0.35)),
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
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(error.message, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  error.instruction,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                  ),
                ),
                if (result.failedPhraseIds.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Фрази: ${result.failedPhraseIds.join(", ")}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (onAction != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(foregroundColor: accent, padding: EdgeInsets.zero),
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

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isWarning ? Colors.orange.shade700 : Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 5),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(error.title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 2),
          Text(error.message, style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}