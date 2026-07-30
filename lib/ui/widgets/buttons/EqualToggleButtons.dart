import 'package:flutter/material.dart';

/// Універсальний рядок кнопок-перемикачів однакового розміру.
///
/// Приймає список елементів будь-якого типу [T] і функцію [labelBuilder],
/// яка перетворює елемент на текст кнопки. Кількість кнопок = items.length,
/// кожна кнопка займає рівну частку ширини (через Expanded).
class EqualToggleButtons<T> extends StatelessWidget {
  const EqualToggleButtons({
    super.key,
    required this.items,
    required this.activeItem,
    required this.onChanged,
    required this.labelBuilder,
    this.spacing = 8,
    this.activeBorderColor = Colors.deepPurpleAccent,
    this.activeFillColor,
    this.inactiveFillColor = Colors.white,
  });

  /// Список значень, для кожного буде своя кнопка.
  final List<T> items;

  /// Поточний активний елемент (порівнюється через ==).
  final T activeItem;

  /// Викликається при натисканні на кнопку з новим значенням.
  final ValueChanged<T> onChanged;

  /// Як дістати текст підпису з елемента, напр. (step) => step.displayName.
  final String Function(T item) labelBuilder;

  /// Відступ між кнопками.
  final double spacing;

  final Color activeBorderColor;
  final Color? activeFillColor;
  final Color inactiveFillColor;

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight змушує Row визначити свою висоту по найвищій дитині,
    // а CrossAxisAlignment.stretch розтягує решту кнопок до цієї ж висоти —
    // так усі кнопки лишаються однаковими, навіть якщо в одній текст
    // переноситься на 2 рядки, а в інших ні.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(child: _buildToggle(items[i])),
          ],
        ],
      ),
    );
  }

  Widget _buildToggle(T item) {
    final isActive = item == activeItem;
    final colorButtonBorder = isActive
        ? activeBorderColor
        : activeBorderColor.withValues(alpha: 0.5);
    final colorButtonInside = isActive
        ? (activeFillColor ?? Colors.grey.shade100)
        : inactiveFillColor;

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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          labelBuilder(item),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}