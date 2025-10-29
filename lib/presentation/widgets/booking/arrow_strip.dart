import 'package:flutter/material.dart';

class ArrowStrip extends StatelessWidget {
  const ArrowStrip({
    required this.child,
    required this.onPrev,
    required this.onNext,
  });

  final Widget child;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _circleIcon(Icons.chevron_left, onPrev, colorScheme),
        const SizedBox(width: 8),
        Expanded(child: child),
        const SizedBox(width: 8),
        _circleIcon(Icons.chevron_right, onNext, colorScheme),
      ],
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap, ColorScheme colors) => InkResponse(
    onTap: onTap,
    radius: 22,
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceContainer,
      ),
      child: Icon(icon, size: 20, color: colors.onSurface),
    ),
  );
}