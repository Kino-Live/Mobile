import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:kinolive_mobile/app/colors_theme.dart';
import 'package:kinolive_mobile/presentation/validators/auth_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/login_vm.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final obscure = useState<bool>(true);
    final email = useTextEditingController();
    final password = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final loginState = ref.watch(loginVmProvider);

    Future<void> onLogin() async {
      if (formKey.currentState!.validate()) {
        await ref.read(loginVmProvider.notifier).login(
          email.text.trim(),
          password.text.trim(),
        );
        context.go('/');
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Header
          Text('Login',
              textAlign: TextAlign.center,
              style: textTheme.headlineLarge?.copyWith(
                color: colorScheme.onSurface,
              )),
          const SizedBox(height: 8),
          Text(
            'Enter your email and password to log in',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 60),

          // Email
          Text('Email',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              )),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            validator: AuthValidators.email,
          ),
          const SizedBox(height: 30),

          // Password
          Text(
            'Password',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          TextFormField(
            controller: password,
            obscureText: obscure.value,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                onPressed: () => obscure.value = !obscure.value,
                icon: Icon(
                  obscure.value ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            validator: AuthValidators.passwordMin6,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/forgot-password'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                'Forgot Password?',
                style: textTheme.bodyMedium?.copyWith(
                  color: myBlue,
                  decoration: TextDecoration.underline,
                  decorationColor: myBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Login button
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: loginState.status == LoginStatus.loading ? null : onLogin,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.primaryContainer,
              ),
              child: Text('Login', style: TextStyle(color: colorScheme.onPrimaryContainer),),
            ),
          ),

          const SizedBox(height: 30),

          // Divider with "Or"
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outline)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('Or',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurface)),
              ),
              Expanded(child: Divider(color: colorScheme.outline)),
            ],
          ),
          const SizedBox(height: 28),

          // Google button
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                // TODO: sign in with Google
              },
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(color: colorScheme.onSurface),
                foregroundColor: colorScheme.onSurface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.g_mobiledata, size: 28);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text('Login with Google'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ",
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant)),
              TextButton(
                onPressed: () => context.go('/register'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text('Sign up', style: TextStyle(color: myBlue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}