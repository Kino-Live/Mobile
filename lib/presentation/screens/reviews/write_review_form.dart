import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/presentation/viewmodels/reviews/write_review_vm.dart';

class WriteReviewForm extends HookConsumerWidget {
  const WriteReviewForm({
    super.key,
    required this.order,
    this.onChanged,
    this.onCancel,
  });

  final Order order;
  final VoidCallback? onChanged;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final rating = useState<int>(0);
    final commentController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final ratingError = useState<String?>(null);

    useEffect(() {
      void listener() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onChanged?.call();
        });
      }
      
      commentController.addListener(listener);
      
      return () {
        commentController.removeListener(listener);
      };
    }, [commentController]);

    final movieTitle = order.movieTitle ?? 'Movie #${order.movieId}';
    final posterUrl = order.posterUrl ?? '';
    final genres = 'Hollywood Movie';
    final language = 'Language: English, Hindi';

    Future<void> onSubmit() async {
      if (rating.value == 0) {
        ratingError.value = 'Please select a rating';
        return;
      }
      ratingError.value = null;

      if (!formKey.currentState!.validate()) return;

      await ref.read(writeReviewVmProvider.notifier).submitReview(
        movieId: order.movieId,
        rating: rating.value,
        comment: commentController.text.trim(),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Please share your valuable review',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 80,
                        height: 100,
                        child: posterUrl.isNotEmpty
                            ? Image.network(
                                posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: colorScheme.surfaceContainerHigh,
                                  child: Icon(
                                    Icons.movie,
                                    color: colorScheme.outlineVariant,
                                    size: 32,
                                  ),
                                ),
                              )
                            : Container(
                                color: colorScheme.surfaceContainerHigh,
                                child: Icon(
                                  Icons.movie,
                                  color: colorScheme.outlineVariant,
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movieTitle,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            genres,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            language,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(order.status, context).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _statusLabel(order.status),
                        style: textTheme.labelSmall?.copyWith(
                          color: _statusColor(order.status, context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Please give your rating with us',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return GestureDetector(
                    onTap: () {
                      rating.value = starIndex;
                      ratingError.value = null;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        onChanged?.call();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        starIndex <= rating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),
              if (ratingError.value != null) ...[
                const SizedBox(height: 8),
                Text(
                  ratingError.value!,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              TextFormField(
                controller: commentController,
                maxLines: 6,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Add a Comment',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outlineVariant,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a comment';
                  }
                  if (value.trim().length > 2000) {
                    return 'Comment must not exceed 2000 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Cancel',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Submit',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== Status Helpers =====================

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

