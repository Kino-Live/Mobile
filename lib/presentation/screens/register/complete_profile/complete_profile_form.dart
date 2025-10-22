import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/app/colors_theme.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  State<CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      // TODO: save name/phone number
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving profile...')),
      );
      context.go(billboardPath);
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
            'Complete your profile',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your name and phone number',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 60),

          // Name
          Text(
            'Name',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
          ),
          const SizedBox(height: 30),

          // Phone number
          Text(
            'Phone number',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter your phone';
              if (v.replaceAll(RegExp(r'\D'), '').length < 7) {
                return 'Phone looks too short';
              }
              return null;
            },
          ),

          const SizedBox(height: 105),

          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _onContinue,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
              child: const Text('Continue'),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: () {
                context.go(billboardPath);
              },
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.surfaceContainer,
                foregroundColor: myBlue,
              ),
              child: const Text('Skip'),
            ),
          ),
        ],
      ),
    );
  }
}
