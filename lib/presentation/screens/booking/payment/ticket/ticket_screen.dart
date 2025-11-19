import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/ticket/ticket_form.dart';

class TicketScreen extends StatelessWidget {
  final String orderId;

  const TicketScreen({
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: TicketForm(
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
    );
  }
}
