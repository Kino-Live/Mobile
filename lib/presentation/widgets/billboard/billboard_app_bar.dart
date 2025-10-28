import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';

class BillboardAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const BillboardAppBar({
    super.key,
    required this.controller,
    required this.searchOpen,
    required this.filtersOpen,
    required this.onToggleSearch,
    required this.onToggleFilters,
    required this.onClearQuery,
  });

  final TextEditingController controller;

  final bool searchOpen;
  final bool filtersOpen;

  final VoidCallback onToggleSearch;
  final VoidCallback onToggleFilters;
  final VoidCallback onClearQuery;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(billboardVmProvider.notifier);
    final state = ref.watch(billboardVmProvider);

    useEffect(() {
      controller.text = state.query;
      return null;
    }, [state.query]);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 72,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      title: SizedBox(
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              ignoring: true,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: searchOpen ? 0 : 1,
                child: Text(
                  'KinoLive',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 72),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SizeTransition(
                      sizeFactor: anim,
                      axisAlignment: -1,
                      child: child,
                    ),
                  ),
                  child: searchOpen
                      ? TextField(
                    key: const ValueKey('search'),
                    controller: controller,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onChanged: vm.setQuery,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Search movies…',
                      isDense: true,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Filters',
                            onPressed: onToggleFilters,
                            icon: Icon(
                              filtersOpen
                                  ? Icons.filter_alt_off
                                  : Icons.filter_alt,
                            ),
                          ),
                          if (state.query.isNotEmpty)
                            IconButton(
                              tooltip: 'Clear',
                              onPressed: () {
                                controller.clear();
                                onClearQuery();
                              },
                              icon: const Icon(Icons.close),
                            ),
                        ],
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  onPressed: onToggleSearch,
                  icon: Icon(
                    searchOpen ? Icons.close : Icons.search,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
