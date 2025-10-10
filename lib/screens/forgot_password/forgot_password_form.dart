import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _onReset() {
    if (_formKey.currentState!.validate()) {
      // TODO: send an email to reset your password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link sent to email')),
      );
      context.push('/forgot-password/check-email', extra: _email.text);
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
          const SizedBox(height: 8),

          // Header
          Text(
            'Forgot password',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please enter your email to reset the password',
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

          const SizedBox(height: 40),

          // Reset Password button
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _onReset,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
              child: const Text('Reset Password'),
            ),
          ),
        ],
      ),
    );
  }
}
