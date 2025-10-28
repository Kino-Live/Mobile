import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/billboard_form.dart';
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
    final isLoading = state.isLoading;

    final index = useState(0);

    Future<void> onNavigation(int i) async {
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

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'KinoLive',
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton.filled(
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
              onPressed: () {},
              icon: Icon(Icons.search, color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LoadingOverlay(
          loading: isLoading,
          child: const BillboardForm(),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: index.value,
        onSelect: onNavigation,
      ),
    );
  }
}
