import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/ticket/ticket_after_payment_form.dart';

class TicketAfterPaymentScreen extends StatelessWidget {
  final String orderId;

  const TicketAfterPaymentScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            color: Colors.black,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: TicketAfterPaymentForm(
                orderId: orderId,
                movieTitle: 'Avengers',
                cinemaName: 'KinoLive Cinema',
                cinemaAddress: 'Kyiv, Some Street 10',
                dateText: '7th May, 19:00',
                ticketsCount: 3,
                seatsText: 'B1 • C1 • C2',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
