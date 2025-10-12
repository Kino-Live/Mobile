import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/viewmodels/register_vm.dart';
import 'package:kinolive_mobile/presentation/screens/register/register_form.dart';

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
        context.go('/register/complete-profile');
      }
    });

    final state = ref.watch(registerVmProvider);
    final isLoading = state.status == RegisterStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: RegisterForm(),
            ),
            AnimatedOpacity(
              opacity: isLoading ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: IgnorePointer(
                ignoring: !isLoading,
                child: Container(
                  color: Colors.black.withAlpha(51),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
