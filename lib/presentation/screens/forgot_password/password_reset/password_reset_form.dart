import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class PasswordResetForm extends StatelessWidget {
  const PasswordResetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Header(
          title: 'Password reset',
          subtitle: 'Your password has been successfully reset.\nClick Confirm to set a new password',
          topSpacing: 8,
          bottomSpacing: 40,
        ),

        PrimaryButton(
          text: 'Confirm',
          onPressed: () => context.go(setPasswordPath),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
      ],
    );
  }
}
