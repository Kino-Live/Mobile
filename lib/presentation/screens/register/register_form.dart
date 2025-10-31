import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/app/design/colors_theme.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/presentation/validators/auth_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/presentation/viewmodels/register_vm.dart';

import 'package:kinolive_mobile/presentation/widgets/auth/footer_text_link.dart';
import 'package:kinolive_mobile/presentation/widgets/auth/google_button.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/labeled_text_field.dart';
import 'package:kinolive_mobile/presentation/widgets/auth/or_divider.dart';
import 'package:kinolive_mobile/presentation/widgets/general/password_field.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';
import 'package:kinolive_mobile/shared/providers/network/google_provider.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final confirm = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final state = ref.watch(registerVmProvider);

    Future<void> onRegister() async {
      if (!formKey.currentState!.validate()) return;
      await ref.read(registerVmProvider.notifier).register(
        email.text.trim(),
        password.text,
      );
    }

    Future<void> onGoogle() async {
      final googleSignIn = ref.read(googleSignInProvider);
      try {
        await googleSignIn.signOut();
        final account = await googleSignIn.signIn();
        if (account == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
              Text('Google sign-in cancelled', textAlign: TextAlign.center),
            ),
          );
          return;
        }
        final auth = await account.authentication;
        final idToken = auth.idToken;
        final accessToken = auth.accessToken;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text('Signed in as ${account.email}', textAlign: TextAlign.center),
          ),
        );

        ref.read(authStateProvider.notifier).markAuthenticated(
          AuthSession(accessToken: idToken ?? accessToken ?? 'fake_token'),
        );

        if (context.mounted) {
          context.go(completeProfilePath);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign-in error: $e',
                textAlign: TextAlign.center),
          ),
        );
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(
            title: 'Register',
            subtitle: 'Create an account to continue',
            topSpacing: 24,
            bottomSpacing: 40,
          ),

          LabeledTextField(
            label: 'Email',
            controller: email,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.email,
            bottomSpacing: 24,
          ),

          PasswordField(
            label: 'Password',
            controller: password,
            hint: 'Enter your password',
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
            bottomSpacing: 32,
          ),

          PrimaryButton(
            text: 'Register',
            onPressed:
            state.status == RegisterStatus.loading ? null : onRegister,
            loading: state.status == RegisterStatus.loading,
            bottomSpacing: 30,
          ),

          OrDivider(
              bottomSpacing: 28
          ),

          GoogleButton(
            text: 'Register with Google',
            onPressed: onGoogle,
            bottomSpacing: 16,
          ),

          FooterTextLink(
            leading: 'Already have an account? ',
            action: 'Login',
            actionColor: myBlue,
            onTap: () => context.go(loginPath),
          ),
        ],
      ),
    );
  }
}
