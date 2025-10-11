import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/login/login_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/login_vm.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginVmProvider, (prev, next) {
      if (next.status == LoginStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
      }
      if (next.status == LoginStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in', textAlign: TextAlign.center)),
        );
      }
    });

    final state = ref.watch(loginVmProvider);
    final isLoading = state.status == LoginStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: LoginForm(),
            ),

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
    );
  }
}
