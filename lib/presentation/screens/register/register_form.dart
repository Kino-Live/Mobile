import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/colors_theme.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/presentation/validators/auth_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/presentation/viewmodels/register_vm.dart';
import 'package:kinolive_mobile/shared/providers/network/google_provider.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final obscure = useState<bool>(true);
    final obscureConfirm = useState<bool>(true);

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
      // TODO: register with Google
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
          SnackBar(
            content: Text('Signed in as ${account.email}',
                textAlign: TextAlign.center),
          ),
        );

        ref.read(authStateProvider.notifier).markAuthenticated(
          AuthSession(accessToken: idToken ?? accessToken ?? 'fake_token'),
        );

        //TODO: This is different part from login
        if (context.mounted) {
          context.go('/register/complete-profile');
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
          const SizedBox(height: 24),

          // Header
          Text(
            'Register',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create an account to continue',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 40),

          // Email
          Text(
            'Email',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
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
          const SizedBox(height: 24),

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
          const SizedBox(height: 24),

          // Confirm Password
          Text(
            'Confirm Password',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          TextFormField(
            controller: confirm,
            obscureText: obscureConfirm.value,
            decoration: InputDecoration(
              hintText: 'Re-enter password',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                onPressed: () =>
                obscureConfirm.value = !obscureConfirm.value,
                icon: Icon(
                  obscureConfirm.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Re-enter password';
              if (v != password.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Register button
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: state.status == RegisterStatus.loading ? null : onRegister,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
              child: const Text('Register'),
            ),
          ),

          const SizedBox(height: 30),

          // Divider with "Or"
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outline)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Or',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurface),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outline)),
            ],
          ),
          const SizedBox(height: 28),

          // Google button
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: onGoogle,
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
                  const Text('Register with Google'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? ",
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
              TextButton(
                onPressed: () => context.go('/login'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text('Login', style: TextStyle(color: myBlue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
