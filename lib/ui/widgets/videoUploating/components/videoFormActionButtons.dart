import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          if (hasAnyData) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  side: const BorderSide(color: Colors.deepPurpleAccent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.4),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: isSubmitEnabled ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}