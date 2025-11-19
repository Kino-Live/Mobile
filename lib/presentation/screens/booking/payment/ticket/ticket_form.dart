import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketForm extends StatelessWidget {
  final String orderId;

  final String movieTitle;
  final String cinemaName;
  final String cinemaAddress;
  final String dateText;
  final int ticketsCount;
  final String seatsText;

  const TicketForm({
    super.key,
    required this.orderId,
    required this.movieTitle,
    required this.cinemaName,
    required this.cinemaAddress,
    required this.dateText,
    required this.ticketsCount,
    required this.seatsText,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),

        Text(
          '"Thank you for purchasing your movie ticket with us.\n'
              'We hope you enjoy your movie experience."',
          textAlign: TextAlign.center,
          style: tt.titleMedium?.copyWith(
            color: cs.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 32),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF15151A),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                movieTitle,
                textAlign: TextAlign.center,
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoBlock(
                    label: 'Date',
                    value: dateText,
                  ),
                  _InfoBlock(
                    label: 'Order',
                    value: orderId,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoBlock(
                    label: 'Tickets',
                    value: '$ticketsCount',
                  ),
                  _InfoBlock(
                    label: 'Seating',
                    value: seatsText,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _InfoBlock(
                label: 'Cinema',
                value: '$cinemaName\n$cinemaAddress',
                crossAxisStart: true,
              ),

              const SizedBox(height: 24),

              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white24,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: QrImageView(
                  data: orderId,
                  version: QrVersions.auto,
                  size: 180,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Scan this QR at the cinema entrance',
                textAlign: TextAlign.center,
                style: tt.bodySmall?.copyWith(
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () => context.go(billboardPath),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1ED760),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Return',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final bool crossAxisStart;

  const _InfoBlock({
    required this.label,
    required this.value,
    this.crossAxisStart = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment:
        crossAxisStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: crossAxisStart ? TextAlign.start : TextAlign.center,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
