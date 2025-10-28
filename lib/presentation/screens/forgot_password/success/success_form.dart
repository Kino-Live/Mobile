import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/widgets/success/success_icon.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class SuccessForm extends StatelessWidget {
  const SuccessForm({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),

        const SuccessIcon(),

        Header(
          title: 'Successful',
          subtitle: 'Congratulations! Your password has been\nchanged. Click continue to login',
          topSpacing: 24,
          bottomSpacing: 40,
        ),

        PrimaryButton(
          text: 'Continue',
          onPressed: () => context.go(loginPath),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
      ],
    );
  }
}
