import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/check_email/check_email_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';

class CheckEmailScreen extends ConsumerWidget {
  const CheckEmailScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(forgotPasswordVmProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
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
          onPressed: () => context.canPop() ? context.pop() : context.pop(),
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          loading: loading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: CheckEmailForm(email: email),
          ),
        ),
      ),
    );
  }
}
