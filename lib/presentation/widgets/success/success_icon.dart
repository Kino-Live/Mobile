import 'package:flutter/material.dart';

class SuccessIcon extends StatelessWidget {
  final double size;
  final double borderWidth;
  final Color? color;

  const SuccessIcon({
    super.key,
    this.size = 96,
    this.borderWidth = 2,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = color ?? colorScheme.primary;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: iconColor, width: borderWidth),
        ),
        child: Icon(Icons.check_rounded, size: size * 0.45, color: iconColor),
      ),
    );
  }
}
