import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/profile/my_tickets/details/ticket_details_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/ticket_details_vm.dart';

class TicketDetailsScreen extends HookConsumerWidget {
  final String orderId;

  const TicketDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final state = ref.watch(ticketDetailsVmProvider(orderId));
    final vm = ref.read(ticketDetailsVmProvider(orderId).notifier);

    // Load order details when entering the screen
    useEffect(() {
      Future.microtask(() => vm.init(orderId));
      return null;
    }, const []);

    // Listen for technical errors — not for "not found"
    ref.listen(ticketDetailsVmProvider(orderId), (prev, next) {
      if (next.hasError && next.error != null) {
        final error = next.error!.toLowerCase();

        if (error.contains('not found')) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );

        vm.clearError();
      }
    });

    Widget body;

    // LOADING
    if (state.isLoading && state.order == null) {
      body = const Center(child: CircularProgressIndicator());
    }

    else if (state.order == null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 72, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'Ticket not found',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This ticket does not exist or was removed',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    // ORDER FOUND — NORMAL UI
    else {
      final order = state.order!;

      final movieTitle = order.movieTitle;
      final cinemaName = order.cinemaName;

      final cinemaAddress = order.cinemaCity.isNotEmpty
          ? '${order.cinemaCity}, ${order.cinemaAddress}'
          : order.cinemaAddress;

      final dateText = _formatTicketDate(order.showStart);
      final ticketsCount = order.ticketsCount;
      final seatsText = order.seats.join(' • ');

      body = SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: TicketDetailsForm(
          orderId: order.id,
          movieTitle: movieTitle,
          cinemaName: cinemaName,
          cinemaAddress: cinemaAddress,
          dateText: dateText,
          ticketsCount: ticketsCount,
          seatsText: seatsText,
        ),
      );
    }

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Ticket details',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: colorScheme.surface,
            child: body,
          ),
        ),
      ),
    );
  }
}

// DATE HELPERS

String _monthName(int month) {
  switch (month) {
    case 1: return 'Jan';
    case 2: return 'Feb';
    case 3: return 'Mar';
    case 4: return 'Apr';
    case 5: return 'May';
    case 6: return 'Jun';
    case 7: return 'Jul';
    case 8: return 'Aug';
    case 9: return 'Sep';
    case 10: return 'Oct';
    case 11: return 'Nov';
    case 12: return 'Dec';
    default: return '';
  }
}

String _formatTicketDate(DateTime dt) {
  final day = dt.day;
  final month = _monthName(dt.month);
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '$day $month, $hh:$mm';
}
