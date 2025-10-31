import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/app/design/colors_theme.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/presentation/validators/auth_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/presentation/viewmodels/login_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/auth/footer_text_link.dart';
import 'package:kinolive_mobile/presentation/widgets/auth/google_button.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/labeled_text_field.dart';
import 'package:kinolive_mobile/presentation/widgets/auth/or_divider.dart';
import 'package:kinolive_mobile/presentation/widgets/general/password_field.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';
import 'package:kinolive_mobile/shared/providers/network/google_provider.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final loginState = ref.watch(loginVmProvider);

    Future<void> onLogin() async {
      if (!formKey.currentState!.validate()) return;

      await ref.read(loginVmProvider.notifier).login(
        email.text.trim(),
        password.text.trim(),
      );
    }

    Future<void> onGoogle() async {
      // TODO: sign in with Google
      final googleSignIn = ref.read(googleSignInProvider);

      try {
        await googleSignIn.signOut();

        final account = await googleSignIn.signIn();

        if (account == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google sign-in cancelled',
                textAlign: TextAlign.center)),
          );
          return;
        }

        final auth = await account.authentication;
        final idToken = auth.idToken;
        final accessToken = auth.accessToken;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in as ${account.email}',
            textAlign: TextAlign.center,)),
        );

        ref.read(authStateProvider.notifier).markAuthenticated(
          AuthSession(accessToken: idToken ?? accessToken ?? 'fake_token'),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in error: $e',
              textAlign: TextAlign.center)),
        );
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(
            title: 'Login',
            subtitle: 'Enter your email and password to log in',
            topSpacing: 24,
            bottomSpacing: 60,
          ),

          LabeledTextField(
            label: 'Email',
            controller: email,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.email,
            bottomSpacing: 30,
          ),

          PasswordField(
            label: 'Password',
            controller: password,
            hint: 'Enter your password',
            validator: AuthValidators.passwordMin6,
            bottomSpacing: 10,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push(forgotPasswordPath),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: myBlue,
                  decoration: TextDecoration.underline,
                  decorationColor: myBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          PrimaryButton(
            text: 'Login',
            onPressed:
            loginState.status == LoginStatus.loading ? null : onLogin,
            loading: loginState.status == LoginStatus.loading,
            bottomSpacing: 30,
          ),

          const OrDivider(
            bottomSpacing: 28,
          ),

          GoogleButton(
            text: 'Login with Google',
            onPressed: onGoogle,
            bottomSpacing: 16,
          ),

          FooterTextLink(
            leading: "Don't have an account? ",
            action: 'Sign up',
            actionColor: myBlue,
            onTap: () => context.go(registerPath),
          ),
        ],
      ),
    );
  }
}
