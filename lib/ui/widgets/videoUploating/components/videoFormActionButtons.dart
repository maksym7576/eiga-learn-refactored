import 'package:flutter/material.dart';
import '../../../styles/VideoUploadingTheme.dart';

class VideoFormActionButtons extends StatelessWidget {
  const VideoFormActionButtons({
    super.key,
    required this.hasAnyData,
    required this.isSubmitEnabled,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool hasAnyData;
  final bool isSubmitEnabled;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = VideoUploadingTheme.of(context);

    return Padding(
      padding: theme.actionsRowPadding,
      child: Row(
        children: [
          if (hasAnyData) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: theme.cancelButtonStyle(),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: isSubmitEnabled ? onSubmit : null,
              style: theme.submitButtonStyle(),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}