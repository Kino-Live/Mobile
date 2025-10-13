import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/check_email/check_email_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';

class CheckEmailScreen extends ConsumerWidget {
  const CheckEmailScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final loading = ref.watch(forgotPasswordVmProvider.select((s) => s.loading));
    final error = ref.watch(forgotPasswordVmProvider.select((s) => s.error));

    ref.listen(forgotPasswordVmProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        leading: IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: CheckEmailForm(email: email),
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
    );
  }
}
