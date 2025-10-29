import 'package:flutter/material.dart';

class QualityChips extends StatelessWidget {
  const QualityChips({
    required this.selectedQuality,
    required this.onSelect2D,
    required this.onSelect3D,
    required this.colorScheme,
    this.is2DAvailable = true,
    this.is3DAvailable = true,
    super.key,
  });

  final String selectedQuality;
  final VoidCallback onSelect2D;
  final VoidCallback onSelect3D;
  final ColorScheme colorScheme;
  final bool is2DAvailable;
  final bool is3DAvailable;

  @override
  Widget build(BuildContext context) {
    final is2DSelected = selectedQuality == '2D';
    final is3DSelected = selectedQuality == '3D';

    Color background(bool selected, bool available) {
      if (!available) return colorScheme.surfaceContainerHigh.withOpacity(0.3);
      if (selected) return colorScheme.primary;
      return colorScheme.surfaceContainerHigh;
    }

    Color textColor(bool selected, bool available) {
      if (!available) return colorScheme.onSurface.withOpacity(0.35);
      if (selected) return colorScheme.onPrimaryContainer;
      return colorScheme.onSurface;
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qualityChip(
            label: '2D',
            selected: is2DSelected,
            available: is2DAvailable,
            onTap: is2DAvailable ? onSelect2D : null,
            bg: background(is2DSelected, is2DAvailable),
            fg: textColor(is2DSelected, is2DAvailable),
          ),
          const SizedBox(width: 12),
          _qualityChip(
            label: '3D',
            selected: is3DSelected,
            available: is3DAvailable,
            onTap: is3DAvailable ? onSelect3D : null,
            bg: background(is3DSelected, is3DAvailable),
            fg: textColor(is3DSelected, is3DAvailable),
          ),
        ],
      ),
    );
  }

  Widget _qualityChip({
    required String label,
    required bool selected,
    required bool available,
    required Color bg,
    required Color fg,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? fg.withOpacity(0.9)
                : available
                ? Colors.transparent
                : fg.withOpacity(0.1),
            width: selected ? 1.2 : 1.0,
          ),
        ),
        constraints: const BoxConstraints(minWidth: 72, minHeight: 46),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}