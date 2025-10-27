import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kinolive_mobile/presentation/screens/forgot_password/set_password/set_password_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/loading_overlay.dart';

class SetPasswordScreen extends ConsumerWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(forgotPasswordVmProvider.select((s) => s.loading));

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: LoadingOverlay(
            loading: loading,
            child: const SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 72, 24, 24),
              child: SetPasswordForm(),
            ),
          ),
        ),
      ),
    );
  }
}
