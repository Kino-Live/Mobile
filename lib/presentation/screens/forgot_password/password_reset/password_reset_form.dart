import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({super.key});

  @override
  State<PasswordResetForm> createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),

        // Header
        Text(
          'Password reset',
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          'Your password has been successfully reset.\n'
              'click confirm to set a new password',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 40),

        // Confirm Button
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: () {
              context.go('/forgot-password/set-password');
            },
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            ),
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }
}