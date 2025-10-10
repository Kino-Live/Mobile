import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessForm extends StatefulWidget {
  const SuccessForm({super.key});

  @override
  State<SuccessForm> createState() => _SuccessFormState();
}

class _SuccessFormState extends State<SuccessForm> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),

        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check_rounded,
              size: 44,
              color: colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Header
        Text(
          'Successful',
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          'Congratulations! Your password has been\n'
              'changed. Click continue to login',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 40),

        // Continue Button
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: () {
              context.go('/login');
            },
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            ),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}
