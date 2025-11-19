import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/profile/my_tickets/details/ticket_details_form.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String orderId;

  const TicketDetailsScreen({
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
              child: TicketDetailsForm(
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
