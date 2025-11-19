import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketAfterPaymentForm extends StatelessWidget {
  final String orderId;
  final String movieTitle;
  final String cinemaName;
  final String cinemaAddress;
  final String dateText;
  final int ticketsCount;
  final String seatsText;

  const TicketAfterPaymentForm({
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
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
                children: [
                  Expanded(
                    child: _InfoBlock(
                      label: 'Date',
                      value: dateText,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoBlock(
                      label: 'Order',
                      value: orderId,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoBlock(
                      label: 'Tickets',
                      value: '$ticketsCount',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoBlock(
                      label: 'Seating',
                      value: seatsText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Cinema',
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$cinemaName\n$cinemaAddress',
                      textAlign: TextAlign.center,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: cs.outline.withOpacity(0.3),
                      width: 1,
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
                  foregroundColor: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan this QR at the cinema entrance',
                textAlign: TextAlign.center,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.6),
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
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Back to menu',
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

    return Column(
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
          textAlign: TextAlign.center,
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
