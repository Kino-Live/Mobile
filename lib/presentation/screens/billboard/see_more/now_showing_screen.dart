import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/see_more/now_showing_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';

class NowShowingScreen extends HookConsumerWidget {
  const NowShowingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      Future.microtask(() => ref.read(billboardVmProvider.notifier).load());
      return null;
    }, const []);

    ref.listen(billboardVmProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
        ref.read(billboardVmProvider.notifier).clearError();
      }
    });

    final state = ref.watch(billboardVmProvider);

    Widget child;
    if (state.isEmpty) {
      child = Center(
        child: Text(
          state.hasError ? (state.error ?? 'Error') : 'No movies yet',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    } else {
      child = NowShowingForm(
        onRefresh: () => ref.read(billboardVmProvider.notifier).load(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Now Showing',
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : null,
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: state.isLoading,
          child: child,
        ),
      ),
    );
  }
}
