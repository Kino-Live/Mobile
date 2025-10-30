import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  const Legend({super.key, required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        _LegendItem(color: cs.primary, filled: true, label: 'Selected'),
        const SizedBox(width: 12),
        _LegendItem(color: cs.secondaryContainer, filled: true, label: 'Reserved'),
        const SizedBox(width: 12),
        _LegendItem(color: cs.outline, filled: false, label: 'Available'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.filled, required this.label});
  final Color color;
  final bool filled;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: tt.labelMedium),
      ],
    );
  }
}