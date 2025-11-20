import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/history_vm.dart';

class TicketsHistoryScreen extends HookConsumerWidget {
  const TicketsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    useEffect(() {
      Future.microtask(
            () => ref.read(ticketsHistoryVmProvider.notifier).load(),
      );
      return null;
    }, const []);

    ref.listen(ticketsHistoryVmProvider, (prev, next) {
      if (next.hasError && next.error != null && next.orders.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textAlign: TextAlign.center),
          ),
        );
        ref.read(ticketsHistoryVmProvider.notifier).clearError();
      }
    });

    final state = ref.watch(ticketsHistoryVmProvider);
    final now = DateTime.now();

    bool isHistoryOrder(Order o) {
      if (o.status != OrderStatus.paid) {
        return true;
      }
      final DateTime showStart = o.showStart ?? o.createdAt;
      return showStart.isBefore(now);
    }

    final List<Order> historyOrders = state.orders
        .where(isHistoryOrder)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    Future<void> reload() async {
      await ref.read(ticketsHistoryVmProvider.notifier).load();
    }

    Widget body;

    if (state.isLoading && historyOrders.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.hasError && historyOrders.isEmpty) {
      body = _ErrorView(
        message: state.error ?? 'Error loading history',
        onRetry: reload,
      );
    } else if (historyOrders.isEmpty) {
      body = _EmptyView(onRefresh: reload);
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: historyOrders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = historyOrders[index];
          return HistoryTicketListItem(
            order: order,
            onViewDetails: () {
              context.pushNamed(
                ticketDetailsName,
                pathParameters: {'orderId': order.id},
              );
            },
            onWriteReview: () {
              // TODO: go to "rate / write a review"
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'History',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: reload,
          child: body,
        ),
      ),
    );
  }
}

/// ========= EMPTY VIEW =========

class _EmptyView extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No history yet',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Buy a ticket and it will appear here',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: onRefresh,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ========= ERROR VIEW =========

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: onRetry,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HistoryTicketListItem extends StatelessWidget {
  const HistoryTicketListItem({
    super.key,
    required this.order,
    this.onViewDetails,
    this.onWriteReview,
  });

  final Order order;
  final VoidCallback? onViewDetails;
  final VoidCallback? onWriteReview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final title = (order.movieTitle != null && order.movieTitle!.isNotEmpty)
        ? order.movieTitle!
        : 'Movie #${order.movieId}';

    final subtitle = 'Seats: ${_shortenSeats(order.seats, max: 5)}';
    final priceLine =
        'Amount: ${order.totalAmount.toStringAsFixed(2)} ${order.currency}';
    final createdAt = _formatDateTime(order.createdAt);

    final statusLabel = _statusLabel(order.status);
    final statusColor = _statusColor(order.status, context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: _PosterImage(posterUrl: order.posterUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            statusLabel,
                            style: textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      priceLine,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created: $createdAt',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'View Details',
                    style:
                    textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onWriteReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Write a Review',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ========= POSTER =========

class _PosterImage extends StatelessWidget {
  final String? posterUrl;

  const _PosterImage({this.posterUrl});

  @override
  Widget build(BuildContext context) {
    if (posterUrl == null || posterUrl!.isEmpty) {
      return Image.asset(
        'assets/images/placeholder_poster.jpg',
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      posterUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/placeholder_poster.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

// ===================== Helpers =====================

String _formatDateTime(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString();
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '$d.$m.$y $hh:$mm';
}

/// "A1, A2, A3, A4, A5..."
String _shortenSeats(List<String> seats, {int max = 5}) {
  if (seats.isEmpty) return '-';
  if (seats.length <= max) {
    return seats.join(', ');
  }
  final visible = seats.take(max).join(', ');
  return '$visible...';
}

String _statusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.paid:
      return 'Paid';
    case OrderStatus.cancelled:
      return 'Cancelled';
    case OrderStatus.refunded:
      return 'Refunded';
    default:
      return 'Unknown';
  }
}

Color _statusColor(OrderStatus status, BuildContext context) {
  switch (status) {
    case OrderStatus.paid:
      return Colors.green;
    case OrderStatus.cancelled:
      return Colors.red;
    case OrderStatus.refunded:
      return Colors.orange;
    default:
      return Theme.of(context).colorScheme.primary;
  }
}
