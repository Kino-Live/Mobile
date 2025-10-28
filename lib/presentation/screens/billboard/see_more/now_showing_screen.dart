import 'package:flutter/material.dart';
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

    Future<void> refresh() async {
      await ref.read(billboardVmProvider.notifier).load();
    }

    final state = ref.watch(billboardVmProvider);
    final isLoading = state.isLoading;

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
          loading: isLoading,
          child: NowShowingForm(
            onRefresh: refresh,
          ),
        ),
      ),
    );
  }
}
