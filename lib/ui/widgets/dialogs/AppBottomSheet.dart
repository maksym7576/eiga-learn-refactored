import 'package:flutter/material.dart';
import '../../styles/AppBottomSheetTheme.dart';

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
    final theme = AppBottomSheetTheme.of(context);

    await showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: theme.barrierColor,
      transitionDuration: theme.transitionDuration,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: _DraggableSheetBody(
              heightFactor: heightFactor,
              backgroundColor: backgroundColor,
              theme: theme,
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
  final AppBottomSheetTheme theme;
  final Widget child;

  const _DraggableSheetBody({
    required this.heightFactor,
    required this.backgroundColor,
    required this.theme,
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
      duration: widget.theme.snapDuration,
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
    final theme = widget.theme;
    final sheetHeight =
        MediaQuery.of(context).size.height * widget.heightFactor;

    return Transform.translate(
      offset: Offset(0, _dragExtent * sheetHeight),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: sheetHeight),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.backgroundColor,
          borderRadius: theme.borderRadius,
          boxShadow: theme.shadow,
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
                padding: theme.handlePadding,
                child: Center(
                  child: Container(
                    width: theme.handleWidth,
                    height: theme.handleHeight,
                    decoration: BoxDecoration(
                      color: theme.handleColor,
                      borderRadius: BorderRadius.circular(theme.handleRadius),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: theme.borderRadius,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}