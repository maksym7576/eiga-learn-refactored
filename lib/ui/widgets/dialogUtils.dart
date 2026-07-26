import 'package:flutter/material.dart';

class DialogUtils {
  static Future<T?> showAnimatedDialog<T>({
    required BuildContext context,
    required Widget child,
    double heightFactor = 0.6,
    double widthFactor = 0.9,
    Color barrierColor = Colors.black54,
    String barrierLabel = "DialogLabel",
    Duration transitionDuration = const Duration(milliseconds: 300),
    Color backgroundColor = Colors.white,
    double borderRadius = 20,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * heightFactor,
                  maxWidth: MediaQuery.of(context).size.width * widthFactor,
                  minWidth: MediaQuery.of(context).size.width * widthFactor,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }
}