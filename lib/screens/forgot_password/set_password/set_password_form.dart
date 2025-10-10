import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetPasswordForm extends StatefulWidget {
  const SetPasswordForm({super.key});

  @override
  State<SetPasswordForm> createState() => _SetPasswordFormState();
}

class _SetPasswordFormState extends State<SetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onUpdate() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send a new password to the server
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated')),
      );
      context.go('/forgot-password/successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    InputDecoration _pwdDecoration({
      required String hint,
      required bool obscure,
      required VoidCallback onToggle,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // Header
          Text(
            'Set a new password',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            'Create a new password. Ensure it differs from\n'
                'previous ones for security',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 40),

          // Password
          Text(
            'Password',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          TextFormField(
            controller: _password,
            obscureText: _obscure1,
            decoration: _pwdDecoration(
              hint: 'Enter your new password',
              obscure: _obscure1,
              onToggle: () => setState(() => _obscure1 = !_obscure1),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter password';
              if (v.length < 8) return 'At least 8 characters';
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Confirm Password
          Text(
            'Confirm Password',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          TextFormField(
            controller: _confirmPassword,
            obscureText: _obscure2,
            decoration: _pwdDecoration(
              hint: 'Re-enter password',
              obscure: _obscure2,
              onToggle: () => setState(() => _obscure2 = !_obscure2),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Re-enter password';
              if (v != _password.text) return 'Passwords do not match';
              return null;
            },
          ),

          const SizedBox(height: 40),

          // Update Password Button
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _onUpdate,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
              child: const Text('Update Password'),
            ),
          ),
        ],
      ),
    );
  }
}
