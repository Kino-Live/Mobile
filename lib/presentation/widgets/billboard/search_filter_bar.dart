import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';

class SearchFiltersBar extends ConsumerWidget {
  const SearchFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(billboardVmProvider);
    final vm = ref.read(billboardVmProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final allGenres = {
      for (final m in state.movies) ...m.genres,
    }.toList()
      ..sort();

    return Material(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('Filters', style: textTheme.titleMedium),
              const Spacer(),
              TextButton.icon(
                onPressed: vm.clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              )
            ]),
            const SizedBox(height: 8),

            if (allGenres.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allGenres.map((g) {
                  final selected = state.selectedGenres.contains(g);
                  return FilterChip(
                    label: Text(g),
                    selected: selected,
                    onSelected: (_) => vm.toggleGenre(g),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            Row(
              children: [
                Text('Min rating: ${state.minRating.toStringAsFixed(1)}'),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: state.minRating.clamp(0, 10),
                    min: 0,
                    max: 10,
                    divisions: 20,
                    label: state.minRating.toStringAsFixed(1),
                    onChanged: vm.setMinRating,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
