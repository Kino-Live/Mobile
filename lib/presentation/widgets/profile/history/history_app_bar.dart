import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/history_filter_vm.dart';

class HistoryAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HistoryAppBar({
    super.key,
    required this.controller,
    required this.searchOpen,
    required this.filtersOpen,
    required this.onToggleSearch,
    required this.onToggleFilters,
    required this.onClearQuery,
    this.showSearch = false,
  });

  final TextEditingController controller;
  final bool searchOpen;
  final bool filtersOpen;
  final VoidCallback onToggleSearch;
  final VoidCallback onToggleFilters;
  final VoidCallback onClearQuery;
  final bool showSearch;

  @override
  Size get preferredSize {
    // Will be calculated in build method, but need a default
    return const Size.fromHeight(72);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(historyFilterVmProvider.notifier);
    final state = ref.watch(historyFilterVmProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      if (showSearch) {
        controller.text = state.query;
      }
      return null;
    }, [state.query, showSearch]);

    final topPadding = MediaQuery.of(context).padding.top;
    
    return Container(
      height: 72 + topPadding,
      padding: EdgeInsets.only(top: topPadding),
      color: Colors.transparent,
      child: Stack(
        children: [
          if (!(showSearch && searchOpen))
            Positioned(
              left: (showSearch && searchOpen) ? 0 : 56,
              right: 72,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: (showSearch && searchOpen) ? 0 : 1,
                  child: Center(
                    child: Text(
                      'History',
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (showSearch && searchOpen)
            Positioned(
              left: 0,
              right: 72,
              top: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: TextField(
                    key: const ValueKey('search'),
                    controller: controller,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onChanged: vm.setQuery,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Search history…',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        tooltip: 'Filters',
                        onPressed: onToggleFilters,
                        icon: Icon(
                          filtersOpen
                              ? Icons.filter_alt_off
                              : Icons.filter_alt,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!(showSearch && searchOpen))
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colorScheme.onSurface,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: showSearch ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !showSearch,
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                  onPressed: showSearch ? onToggleSearch : null,
                  icon: Icon(
                    searchOpen ? Icons.close : Icons.search,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
