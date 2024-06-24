import 'package:flutter/material.dart';

/// Opens a dialog starting from a tap position.
Future<void> showCustomDialog(
  BuildContext context,
  Offset tapPosition,
  String barrierLabel,
  Widget child,
) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: barrierLabel,
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      final x = ((tapPosition.dx * 2)
        / MediaQuery.of(context).size.width)
        - 1.0;
      final y = ((tapPosition.dy * 2)
        / MediaQuery.of(context).size.height)
        - 1.0;
      return AlignTransition(
        alignment: Tween<AlignmentGeometry>(
          begin: Alignment(x, y),
          end: Alignment.center,
        ).animate(animation),
        child: ScaleTransition(
          scale: animation,
          child: Material(
            child: child,
          ),
        ),
      );
    },
  );
}