import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/success/success_payment_form.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;

  const PaymentSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
            child: PaymentSuccessForm(orderId: orderId),
          ),
        ),
      ),
    );
  }
}
