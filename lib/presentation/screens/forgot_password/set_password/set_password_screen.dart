import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/set_password/set_password_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';

class SetPasswordScreen extends ConsumerWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(forgotPasswordVmProvider.select((s) => s.loading));

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              const SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 72, 24, 24),
                child: SetPasswordForm(),
              ),
              AnimatedOpacity(
                opacity: loading ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: IgnorePointer(
                  ignoring: !loading,
                  child: Container(
                    color: Colors.black.withAlpha(51),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
