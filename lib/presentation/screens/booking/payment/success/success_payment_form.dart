import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/presentation/widgets/success/success_icon.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class PaymentSuccessForm extends StatelessWidget {
  final String orderId;

  const PaymentSuccessForm({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const SuccessIcon(),

        Header(
          title: 'Congratulations!',
          subtitle:
          'You have successfully purchased your movie tickets.\nEnjoy the movie!',
          topSpacing: 24,
          bottomSpacing: 40,
        ),

        PrimaryButton(
          text: 'View E-Ticket',
          onPressed: () => context.goNamed(
            ticketAfterPaymentName,
            pathParameters: {'orderId': orderId},
          ),
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimaryContainer,
        ),

        const SizedBox(height: 16),

        PrimaryButton(
          text: 'Go to Home',
          onPressed: () => context.go(billboardPath),
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimaryContainer,
        ),
      ],
    );
  }
}
