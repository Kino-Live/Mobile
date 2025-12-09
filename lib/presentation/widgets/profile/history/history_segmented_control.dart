import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/profile/history/history_screen.dart';

class HistorySegmentedControl extends StatelessWidget {
  final HistoryTab selectedTab;
  final ValueChanged<HistoryTab> onTabChanged;

  const HistorySegmentedControl({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: 'Movies',
              isSelected: selectedTab == HistoryTab.movies,
              onTap: () => onTabChanged(HistoryTab.movies),
              colorScheme: colorScheme,
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: 'Reviews',
              isSelected: selectedTab == HistoryTab.reviews,
              onTap: () => onTabChanged(HistoryTab.reviews),
              colorScheme: colorScheme,
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: 'Promocodes',
              isSelected: selectedTab == HistoryTab.promocodes,
              onTap: () => onTabChanged(HistoryTab.promocodes),
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? colorScheme.primary
        : Colors.transparent;
    final textColor = isSelected
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

