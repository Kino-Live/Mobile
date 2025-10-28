import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/forgot_password_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(forgotPasswordVmProvider, (prev, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
      }
    });

    final loading = ref.watch(
      forgotPasswordVmProvider.select((s) => s.loading),
    );

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        leading: IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
          onPressed: () => context.canPop() ? context.pop() : context.go(loginPath),
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          loading: loading,
          child: const SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: ForgotPasswordForm(),
          ),
        ),
      ),
    );
  }
}
