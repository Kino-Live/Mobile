import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/presentation/validators/auth_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/password_field.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class SetPasswordForm extends HookConsumerWidget {
  const SetPasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useTextEditingController();
    final confirm = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final loading = ref.watch(forgotPasswordVmProvider.select((s) => s.loading));
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> onUpdate() async {
      if (!formKey.currentState!.validate()) return;

      final ok = await ref
          .read(forgotPasswordVmProvider.notifier)
          .setNewPassword(password.text.trim());

      final state = ref.read(forgotPasswordVmProvider);

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated', textAlign: TextAlign.center)),
        );
        context.go(successfulPath);
      } else if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!, textAlign: TextAlign.center)),
        );
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(
            title: 'Set a new password',
            subtitle: 'Create a new password. Ensure it differs from previous ones for security',
            topSpacing: 8,
            bottomSpacing: 40,
          ),

          PasswordField(
            label: 'Password',
            controller: password,
            hint: 'Enter your new password',
            validator: AuthValidators.passwordMin6,
            bottomSpacing: 24,
          ),

          PasswordField(
            label: 'Confirm Password',
            controller: confirm,
            hint: 'Re-enter password',
            validator: (v) {
              if (v == null || v.isEmpty) return 'Re-enter password';
              if (v != password.text) return 'Passwords do not match';
              return null;
            },
            bottomSpacing: 40,
          ),

          PrimaryButton(
            text: 'Update Password',
            onPressed: loading ? null : onUpdate,
            loading: loading,
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}
