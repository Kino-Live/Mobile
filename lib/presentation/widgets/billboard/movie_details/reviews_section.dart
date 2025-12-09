import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';

class ReviewsSection extends StatelessWidget {
  final int movieId;
  final List<Review> reviews;
  final bool isLoading;
  final String? error;

  const ReviewsSection({
    super.key,
    required this.movieId,
    required this.reviews,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final displayedReviews = reviews.take(3).toList();
    final hasMoreReviews = reviews.length > 3;

    if (isLoading && reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null && reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    if (reviews.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Reviews',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            if (hasMoreReviews)
              TextButton(
                onPressed: () {
                  context.pushNamed(
                    movieReviewsName,
                    pathParameters: {'id': movieId.toString()},
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...displayedReviews.map((review) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ReviewItem(review: review),
            )),
        if (hasMoreReviews)
          Center(
            child: TextButton(
              onPressed: () {
                context.pushNamed(
                  movieReviewsName,
                  pathParameters: {'id': movieId.toString()},
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
              ),
              child: Text('View all ${reviews.length} reviews'),
            ),
          ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Review review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Получаем локаль устройства
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final createdAt = _formatDateTime(review.createdAt, deviceLocale);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1D22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.userName,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
            ],
          ),
          const SizedBox(height: 4),
          Text(
            createdAt,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white54,
            ),
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
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

  String _formatDateTime(DateTime dt, Locale locale) {
    try {
      // Используем локаль устройства, если доступна, иначе fallback на 'en'
      final localeString = locale.toString();
      final dateFormat = DateFormat('d MMM yyyy, HH:mm', localeString);
      final formatted = dateFormat.format(dt.toLocal());
      // Капитализируем первую букву месяца
      return formatted.split(' ').map((word) {
        if (word.length > 0 && word.contains(RegExp(r'[a-zA-Z]'))) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }
        return word;
      }).join(' ');
    } catch (e) {
      // Fallback если локализация не работает
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final localDt = dt.toLocal();
      final hh = localDt.hour.toString().padLeft(2, '0');
      final mm = localDt.minute.toString().padLeft(2, '0');
      return '${localDt.day} ${months[localDt.month - 1]} ${localDt.year}, $hh:$mm';
    }
  }
}

