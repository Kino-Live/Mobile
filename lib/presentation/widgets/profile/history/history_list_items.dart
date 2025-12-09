import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/promocodes_history_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_poster_image.dart';
import 'package:kinolive_mobile/shared/utils/history_helpers.dart';

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

    final subtitle = 'Seats: ${shortenSeats(order.seats, max: 5)}';
    final priceLine =
        'Amount: ${order.totalAmount.toStringAsFixed(2)} ${order.currency}';
    final createdAt = formatDateTime(order.createdAt);

    final statusLabelText = statusLabel(order.status);
    final statusColorValue = statusColor(order.status, context);

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
                  child: HistoryPosterImage(posterUrl: order.posterUrl),
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
                            color: statusColorValue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            statusLabelText,
                            style: textTheme.labelSmall?.copyWith(
                              color: statusColorValue,
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

class HistoryReviewListItem extends StatelessWidget {
  final Review review;

  const HistoryReviewListItem({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final movieTitle = review.movieTitle ?? 'Movie #${review.movieId}';
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final createdAt = formatReviewDateTime(review.createdAt, deviceLocale.toString());

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (review.posterUrl != null && review.posterUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: HistoryPosterImage(posterUrl: review.posterUrl),
                  ),
                ),
              if (review.posterUrl != null && review.posterUrl!.isNotEmpty)
                const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movieTitle,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return Icon(
                          starIndex <= review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
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
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class HistoryPromocodeListItem extends StatelessWidget {
  final Promocode promocode;

  const HistoryPromocodeListItem({
    super.key,
    required this.promocode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final statusLabel = promocode.status == PromocodeStatus.used
        ? 'Used'
        : 'Not Used';
    final statusColorValue = promocode.status == PromocodeStatus.used
        ? Colors.green
        : Colors.orange;

    String discountText = '';
    if (promocode.discountPercent != null) {
      discountText = '${promocode.discountPercent}% off';
    } else if (promocode.discountAmount != null) {
      discountText = '\$${promocode.discountAmount!.toStringAsFixed(2)} off';
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promocode.code,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (discountText.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        discountText,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                    if (promocode.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        promocode.description!,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColorValue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: textTheme.labelSmall?.copyWith(
                    color: statusColorValue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (promocode.usedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Used: ${formatDateTime(promocode.usedAt!)}',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white38,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

