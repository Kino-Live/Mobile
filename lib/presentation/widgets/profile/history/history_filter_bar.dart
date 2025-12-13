import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/history_filter_vm.dart';

class HistoryFilterBar extends ConsumerWidget {
  const HistoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyFilterVmProvider);
    final vm = ref.read(historyFilterVmProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Filters', style: textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: vm.clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: state.selectedCategory == HistoryFilterCategory.all,
                  onSelected: () => vm.setCategory(HistoryFilterCategory.all),
                ),
                _CategoryChip(
                  label: 'Online',
                  selected: state.selectedCategory == HistoryFilterCategory.online,
                  onSelected: () => vm.setCategory(HistoryFilterCategory.online),
                ),
                _CategoryChip(
                  label: 'Paid',
                  selected: state.selectedCategory == HistoryFilterCategory.paid,
                  onSelected: () => vm.setCategory(HistoryFilterCategory.paid),
                ),
                _CategoryChip(
                  label: 'Refunded',
                  selected: state.selectedCategory == HistoryFilterCategory.refunded,
                  onSelected: () => vm.setCategory(HistoryFilterCategory.refunded),
                ),
                _CategoryChip(
                  label: 'Cancelled',
                  selected: state.selectedCategory == HistoryFilterCategory.cancelled,
                  onSelected: () => vm.setCategory(HistoryFilterCategory.cancelled),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

