import 'package:flutter/material.dart';

class PillChip extends StatelessWidget {
  const PillChip({
    required this.child,
    required this.onTap,
    required this.selected,
    required this.colors,
    this.height = 56,
    this.minWidth = 64,
    this.horizontalPadding = 16,
    this.radius = 16,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool selected;
  final ColorScheme colors;
  final double height;
  final double minWidth;
  final double horizontalPadding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? colors.primary : colors.surfaceContainerHigh;
    final borderRadius = BorderRadius.circular(radius);

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height, minWidth: minWidth),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius),
          child: Center(child: child),
        ),
      ),
    );
  }
}