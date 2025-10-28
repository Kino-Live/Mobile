import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/billboard_form.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/search_filter_bar.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/bottom_nav_bar.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';

class BillboardScreen extends HookConsumerWidget {
  const BillboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      final wasAuthed = prev?.isAuthenticated == true;
      final nowAuthed = next.isAuthenticated;
      if (wasAuthed && !nowAuthed) {
        final m = ScaffoldMessenger.of(context);
        m.hideCurrentSnackBar();
        m.showSnackBar(
          const SnackBar(content: Text('Logged out', textAlign: TextAlign.center)),
        );
      }
    });

    final state = ref.watch(billboardVmProvider);
    final vm = ref.read(billboardVmProvider.notifier);
    final isLoading = state.isLoading;

    final index = useState(0);

    final searchOpen = useState(false);
    final filtersOpen = useState(false);
    final controller = useTextEditingController(text: state.query);

    useEffect(() {
      controller.text = state.query;
      return null;
    }, [state.query]);

    void resetSearchAndFilters() {
      controller.clear();
      vm.clearQuery();
      vm.clearFilters();
      searchOpen.value = false;
      filtersOpen.value = false;
      FocusScope.of(context).unfocus();
    }

    Future<void> onNavigation(int i) async {
      resetSearchAndFilters();

      final prev = index.value;
      index.value = i;

      if (i == 0 && prev == 0) {
        await ref.read(billboardVmProvider.notifier).load();
        return;
      }
      switch (i) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          await ref.read(authStateProvider.notifier).logout();
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
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
                  opacity: searchOpen.value ? 0 : 1,
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
                    child: searchOpen.value
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
                              onPressed: () => filtersOpen.value = !filtersOpen.value,
                              icon: Icon(
                                filtersOpen.value
                                    ? Icons.filter_alt_off
                                    : Icons.filter_alt,
                              ),
                            ),
                            if (state.query.isNotEmpty)
                              IconButton(
                                tooltip: 'Clear',
                                onPressed: () {
                                  controller.clear();
                                  vm.clearQuery();
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
                    onPressed: () {
                      if (searchOpen.value) {
                        controller.clear();
                        vm.clearQuery();
                        filtersOpen.value = false;
                        FocusScope.of(context).unfocus();
                      }
                      searchOpen.value = !searchOpen.value;
                    },
                    icon: Icon(
                      searchOpen.value ? Icons.close : Icons.search,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: (searchOpen.value && filtersOpen.value)
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: const SearchFiltersBar(),
            ),
            Expanded(
              child: LoadingOverlay(
                loading: isLoading,
                child: BillboardForm(
                  onRefresh: () async {
                    resetSearchAndFilters();
                    await ref.read(billboardVmProvider.notifier).load();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: index.value,
        onSelect: onNavigation,
      ),
    );
  }
}

