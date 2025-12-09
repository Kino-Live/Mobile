import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_empty_states.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_error_view.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_list_items.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_segmented_control.dart';
import 'package:kinolive_mobile/shared/utils/history_helpers.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/history_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/promocodes_history_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/reviews_history_vm.dart';

enum HistoryTab { movies, reviews, promocodes }

class TicketsHistoryScreen extends HookConsumerWidget {
  const TicketsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final selectedTab = useState<HistoryTab>(HistoryTab.movies);

    useEffect(() {
      Future.microtask(() {
        ref.read(ticketsHistoryVmProvider.notifier).load();
        ref.read(reviewsHistoryVmProvider.notifier).load();
        ref.read(promocodesHistoryVmProvider.notifier).load();
      });
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: HistorySegmentedControl(
                selectedTab: selectedTab.value,
                onTabChanged: (tab) {
                  selectedTab.value = tab;
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  switch (selectedTab.value) {
                    case HistoryTab.movies:
                      await ref.read(ticketsHistoryVmProvider.notifier).load();
                      break;
                    case HistoryTab.reviews:
                      await ref.read(reviewsHistoryVmProvider.notifier).load();
                      break;
                    case HistoryTab.promocodes:
                      await ref.read(promocodesHistoryVmProvider.notifier).load();
                      break;
                  }
                },
                child: _buildTabContent(context, ref, selectedTab.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, WidgetRef ref, HistoryTab tab) {
    switch (tab) {
      case HistoryTab.movies:
        return _buildMoviesTab(context, ref);
      case HistoryTab.reviews:
        return _buildReviewsTab(context, ref);
      case HistoryTab.promocodes:
        return _buildPromocodesTab(context, ref);
    }
  }

  Widget _buildMoviesTab(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ticketsHistoryVmProvider);

    final List<Order> historyOrders = state.orders
        .where(isHistoryOrder)
        .toList()
      ..sort((a, b) {
        final ka = historySortKey(a);
        final kb = historySortKey(b);
        return kb.compareTo(ka);
      });

    Future<void> reload() async {
      await ref.read(ticketsHistoryVmProvider.notifier).load();
    }

    Widget body;

    if (state.isLoading && historyOrders.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.hasError && historyOrders.isEmpty) {
      body = HistoryErrorView(
        message: state.error ?? 'Error loading history',
        onRetry: reload,
      );
    } else if (historyOrders.isEmpty) {
      body = HistoryEmptyView(onRefresh: reload);
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
              context.pushNamed(
                writeReviewName,
                extra: order,
              );
            },
          );
        },
      );
    }

    return body;
  }

  Widget _buildReviewsTab(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewsHistoryVmProvider);

    Future<void> reload() async {
      await ref.read(reviewsHistoryVmProvider.notifier).load();
    }

    ref.listen(reviewsHistoryVmProvider, (prev, next) {
      if (next.hasError && next.error != null && next.reviews.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textAlign: TextAlign.center),
          ),
        );
        ref.read(reviewsHistoryVmProvider.notifier).clearError();
      }
    });

    final List<Review> sortedReviews = List<Review>.from(state.reviews)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    Widget body;

    if (state.isLoading && sortedReviews.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.hasError && sortedReviews.isEmpty) {
      body = HistoryErrorView(
        message: state.error ?? 'Error loading reviews',
        onRetry: reload,
      );
    } else if (sortedReviews.isEmpty) {
      body = HistoryEmptyReviewsView(onRefresh: reload);
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: sortedReviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final review = sortedReviews[index];
          return HistoryReviewListItem(review: review);
        },
      );
    }

    return body;
  }

  Widget _buildPromocodesTab(BuildContext context, WidgetRef ref) {
    final state = ref.watch(promocodesHistoryVmProvider);

    Future<void> reload() async {
      await ref.read(promocodesHistoryVmProvider.notifier).load();
    }

    ref.listen(promocodesHistoryVmProvider, (prev, next) {
      if (next.hasError && next.error != null && next.promocodes.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textAlign: TextAlign.center),
          ),
        );
        ref.read(promocodesHistoryVmProvider.notifier).clearError();
      }
    });

    final List<Promocode> sortedPromocodes = List<Promocode>.from(state.promocodes)
      ..sort((a, b) {
        if (a.usedAt != null && b.usedAt != null) {
          return b.usedAt!.compareTo(a.usedAt!);
        }
        if (a.usedAt != null) return -1;
        if (b.usedAt != null) return 1;
        return b.id.compareTo(a.id);
      });

    Widget body;

    if (state.isLoading && sortedPromocodes.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.hasError && sortedPromocodes.isEmpty) {
      body = HistoryErrorView(
        message: state.error ?? 'Error loading promocodes',
        onRetry: reload,
      );
    } else if (sortedPromocodes.isEmpty) {
      body = HistoryEmptyPromocodesView(onRefresh: reload);
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: sortedPromocodes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final promocode = sortedPromocodes[index];
          return HistoryPromocodeListItem(promocode: promocode);
        },
      );
    }

    return body;
  }
}
