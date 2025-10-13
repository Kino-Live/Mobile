import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/forgot_password_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(forgotPasswordVmProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
      }
    });

    final colorScheme = Theme.of(context).colorScheme;
    final loading = ref.watch(forgotPasswordVmProvider.select((s) => s.loading));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        leading: IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
          onPressed: () => context.go('/login'),
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ForgotPasswordForm(),
            ),
            // loading overlay как в LoginScreen
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
    );
  }
}
