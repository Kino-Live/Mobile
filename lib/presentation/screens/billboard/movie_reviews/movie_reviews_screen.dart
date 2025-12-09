import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/presentation/viewmodels/movie_reviews_vm.dart';

class MovieReviewsScreen extends HookConsumerWidget {
  final int movieId;

  const MovieReviewsScreen({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieReviewsVmProvider(movieId));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    useEffect(() {
      ref.read(movieReviewsVmProvider(movieId).notifier).load(movieId);
      return null;
    }, [movieId]);

    ref.listen(movieReviewsVmProvider(movieId), (prev, next) {
      if (next.hasError && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textAlign: TextAlign.center),
          ),
        );
        ref.read(movieReviewsVmProvider(movieId).notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'Reviews',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildBody(context, ref, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, MovieReviewsState state) {
    if (state.isLoading && state.reviews.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && state.reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.error ?? 'Error loading reviews',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(movieReviewsVmProvider(movieId).notifier).load(movieId);
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (state.reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No reviews yet',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to leave a review!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(movieReviewsVmProvider(movieId).notifier).load(movieId);
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: state.reviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final review = state.reviews[index];
          return _ReviewCard(review: review);
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final createdAt = _formatDateTime(review.createdAt, deviceLocale);

    return Container(
      padding: const EdgeInsets.all(16),
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
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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
                    size: 20,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            createdAt,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white54,
            ),
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt, Locale locale) {
    try {
      final localeString = locale.toString();
      final dateFormat = DateFormat('d MMM yyyy, HH:mm', localeString);
      final formatted = dateFormat.format(dt.toLocal());
      return formatted.split(' ').map((word) {
        if (word.length > 0 && word.contains(RegExp(r'[a-zA-Z]'))) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }
        return word;
      }).join(' ');
    } catch (e) {
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

