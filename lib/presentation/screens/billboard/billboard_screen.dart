import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/billboard_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/bottom_nav_bar.dart';

class BillboardScreen extends ConsumerStatefulWidget {
  const BillboardScreen({super.key});

  @override
  ConsumerState<BillboardScreen> createState() => _BillboardScreenState();
}

class _BillboardScreenState extends ConsumerState<BillboardScreen> {
  int _currentIndex = 0;

  Future<void> _onNavItemSelected(int index) async {
    final prev = _currentIndex;
    setState(() => _currentIndex = index);
    if (index == 0 && prev == 0) {
      await ref.read(billboardVmProvider.notifier).load();
      return;
    }
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        await ref.read(authStateProvider.notifier).logout();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (prev, next) {
      final wasAuthed = prev?.isAuthenticated == true;
      final nowAuthed = next.isAuthenticated;
      if (wasAuthed && !nowAuthed) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          const SnackBar(content: Text('Logged out', textAlign: TextAlign.center)),
        );
      }
    });

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(billboardVmProvider);
    final isLoading = state.isLoading;

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
        child: Stack(
          children: [
            const BillboardForm(),
            AnimatedOpacity(
              opacity: isLoading ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: IgnorePointer(
                ignoring: !isLoading,
                child: Container(
                  color: Colors.black.withAlpha(51),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onSelect: _onNavItemSelected,
      ),
    );
  }
}
