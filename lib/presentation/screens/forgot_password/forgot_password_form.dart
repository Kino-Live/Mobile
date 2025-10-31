import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/presentation/validators/auth_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/labeled_text_field.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class ForgotPasswordForm extends HookConsumerWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final loading = ref.watch(
      forgotPasswordVmProvider.select((s) => s.loading),
    );

    Future<void> onReset() async {
      if (!formKey.currentState!.validate()) return;

      final value = email.text.trim();
      final ok = await ref.read(forgotPasswordVmProvider.notifier).sendCode(value);
      if (ok) {
        context.push(checkEmailPath, extra: value);
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(
            title: 'Forgot password',
            subtitle: 'Please enter your email to reset the password',
            topSpacing: 8,
            bottomSpacing: 40,
          ),

          LabeledTextField(
            label: 'Email',
            controller: email,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.email,
            bottomSpacing: 40,
          ),

          PrimaryButton(
            text: 'Reset Password',
            onPressed: loading ? null : onReset,
            loading: loading,
          ),
        ],
      ),
    );
  }
}
