import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/viewmodels/register_vm.dart';
import 'package:kinolive_mobile/presentation/screens/register/register_form.dart';
import 'package:kinolive_mobile/presentation/widgets/auth.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(registerVmProvider, (prev, next) {
      if (next.status == RegisterStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
      }
      if (next.status == RegisterStatus.success) {
        context.go(completeProfilePath);
      }
    });

    final state = ref.watch(registerVmProvider);
    final isLoading = state.status == RegisterStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: LoadingOverlay(
          loading: isLoading,
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
