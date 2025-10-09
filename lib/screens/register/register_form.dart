import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/design/colors.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      // TODO: Create account logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registering...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
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
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (v) =>
            (v == null || v.isEmpty) ? 'Enter your email' : null,
          ),
          const SizedBox(height: 24),

          // Password
          Text(
            'Password',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            validator: (v) =>
            (v == null || v.length < 6) ? 'Min 6 characters' : null,
          ),
          const SizedBox(height: 24),

          // Confirm Password
          Text(
            'Confirm Password',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          TextFormField(
            controller: _confirm,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              hintText: 'Re-enter password',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Re-enter password';
              if (v != _password.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Register button
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _onRegister,
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
              onPressed: () {
                // TODO: register with Google
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
