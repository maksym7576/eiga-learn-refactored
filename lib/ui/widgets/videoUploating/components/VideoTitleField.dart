import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';

class VideoTitleField extends StatelessWidget {
  const VideoTitleField({
    super.key,
    required this.controller,
    this.onSearch,
    this.isLoading = false,
    this.onToggleResults,
    this.isResultsVisible = false,
    this.showToggle = false,
  });

  final TextEditingController controller;
  final VoidCallback? onSearch;
  final bool isLoading;
  final VoidCallback? onToggleResults;
  final bool isResultsVisible;
  final bool showToggle;

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        onSubmitted: (_) => onSearch?.call(),
        textInputAction: TextInputAction.search,
        style: TextStyle(color: theme.normalText, fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.inputBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.focusedInputBorderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.inputBorderColor),
          ),
          prefixIcon: IconButton(
            icon: Icon(Icons.search, color: theme.mutedText, size: 18),
            onPressed: onSearch,
            splashRadius: 20,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
          suffixIcon: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.selectionAccentColor,
                    ),
                  ),
                )
              : showToggle && onToggleResults != null
                  ? IconButton(
                      icon: Icon(
                        isResultsVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: theme.subtitleColor,
                        size: 22,
                      ),
                      onPressed: onToggleResults,
                    )
                  : null,
        ),
      ),
    );
  }
}
