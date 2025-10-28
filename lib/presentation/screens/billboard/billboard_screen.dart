import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/billboard_app_bar.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/billboard_form.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/search_filter_bar.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/bottom_nav_bar.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';
import 'package:kinolive_mobile/presentation/widgets/general/retry_view.dart';

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

    final searchOpen = useState(false);
    final filtersOpen = useState(false);
    final controller = useTextEditingController(text: state.query);

    void resetSearchAndFilters() {
      controller.clear();
      vm.clearQuery();
      vm.clearFilters();
      searchOpen.value = false;
      filtersOpen.value = false;
      FocusScope.of(context).unfocus();
    }

    Future<void> _retry() async {
      resetSearchAndFilters();
      await vm.load();
    }

    return Scaffold(
      appBar: BillboardAppBar(
        controller: controller,
        searchOpen: searchOpen.value,
        filtersOpen: filtersOpen.value,
        onToggleSearch: () {
          if (searchOpen.value) {
            controller.clear();
            vm.clearQuery();
            filtersOpen.value = false;
            FocusScope.of(context).unfocus();
          }
          searchOpen.value = !searchOpen.value;
        },
        onToggleFilters: () => filtersOpen.value = !filtersOpen.value,
        onClearQuery: vm.clearQuery,
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
                child: state.hasError && state.isEmpty
                    ? RetryView(
                  message: state.error ?? 'Loading error',
                  onRetry: _retry,
                )
                    : BillboardForm(
                  onRefresh: _retry,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        initialIndex: 0,
        onResetUi: resetSearchAndFilters,
      ),
    );
  }
}
