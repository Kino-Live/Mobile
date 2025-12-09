import 'package:flutter/material.dart';

class HistoryEmptyView extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const HistoryEmptyView({
    super.key,
    required this.onRefresh,
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

class HistoryEmptyReviewsView extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const HistoryEmptyReviewsView({
    super.key,
    required this.onRefresh,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 64,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reviews yet',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Leave a review and it will appear here',
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

class HistoryEmptyPromocodesView extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const HistoryEmptyPromocodesView({
    super.key,
    required this.onRefresh,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 64,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No promocodes yet',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your promocodes will appear here',
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

