import 'package:flutter/material.dart';

class AppBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    String barrierLabel = "BottomSheetLabel",
    Color? backgroundColor,
    double heightFactor = 1.0,
    bool barrierDismissible = true,
    bool isScrollControlled = true,
    VoidCallback? onClosed,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: _DraggableSheetBody(
              heightFactor: heightFactor,
              backgroundColor: backgroundColor,
              isDark: isDark,
              child: child,
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        // Виїзд знизу вгору
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );

    onClosed?.call();
  }
}

class _DraggableSheetBody extends StatefulWidget {
  final double heightFactor;
  final Color? backgroundColor;
  final bool isDark;
  final Widget child;

  const _DraggableSheetBody({
    required this.heightFactor,
    required this.backgroundColor,
    required this.isDark,
    required this.child,
  });

  @override
  State<_DraggableSheetBody> createState() => _DraggableSheetBodyState();
}

class _DraggableSheetBodyState extends State<_DraggableSheetBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _snapController;

  double _dragExtent = 0;

  static const double _closeExtentThreshold = 0.28;
  static const double _closeVelocityThreshold = 700;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
      setState(() => _dragExtent = _snapController.value);
    });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _snapController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details, double sheetHeight) {
    if (sheetHeight <= 0) return;
    setState(() {
      _dragExtent =
          (_dragExtent + details.delta.dy / sheetHeight).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    final shouldClose = _dragExtent > _closeExtentThreshold ||
        velocity > _closeVelocityThreshold;

    if (shouldClose) {
      Navigator.of(context).maybePop();
      return;
    }

    _snapController.value = _dragExtent;
    _snapController.animateTo(0, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight =
        MediaQuery.of(context).size.height * widget.heightFactor;

    return Transform.translate(
      offset: Offset(0, _dragExtent * sheetHeight),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: sheetHeight),
        decoration: BoxDecoration(
          color: widget.backgroundColor ??
              (widget.isDark ? const Color(0xFF1C1C1E) : Colors.white),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: _onDragStart,
              onVerticalDragUpdate: (d) =>
                  _onDragUpdate(d, sheetHeight),
              onVerticalDragEnd: _onDragEnd,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: widget.isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}