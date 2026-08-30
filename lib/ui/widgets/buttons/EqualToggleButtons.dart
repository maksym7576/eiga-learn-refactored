import 'package:flutter/material.dart';

class EqualToggleButtons<T> extends StatelessWidget {
  const EqualToggleButtons({
    super.key,
    required this.items,
    required this.activeItem,
    required this.onChanged,
    required this.labelBuilder,
    this.spacing = 8,
    this.activeBorderColor,
    this.activeFillColor,
    this.inactiveFillColor,
  });

  final List<T> items;
  final T activeItem;
  final ValueChanged<T> onChanged;
  final String Function(T item) labelBuilder;
  final double spacing;

  final Color? activeBorderColor;
  final Color? activeFillColor;
  final Color? inactiveFillColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(child: _buildToggle(items[i], context)),
          ],
        ],
      ),
    );
  }

  Widget _buildToggle(T item, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = activeBorderColor ?? Colors.indigo;
    
    final isActive = item == activeItem;
    final colorButtonBorder = isActive
        ? accent
        : accent.withValues(alpha: 0.3);
    
    final colorButtonInside = isActive
        ? (activeFillColor ?? accent.withValues(alpha: 0.1))
        : (inactiveFillColor ?? (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white));

    return GestureDetector(
      onTap: () => onChanged(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: colorButtonInside,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorButtonBorder,
            width: isActive ? 2.5 : 1.5,
          ),
        ),
        child: Text(
          labelBuilder(item),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}