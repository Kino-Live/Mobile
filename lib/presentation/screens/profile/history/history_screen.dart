import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/entities/promocodes/promocode.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/entities/online_movies/online_movie.dart';
import 'package:kinolive_mobile/presentation/screens/reviews/write_review_screen.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_empty_states.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_error_view.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_list_items.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_segmented_control.dart';
import 'package:kinolive_mobile/shared/utils/history_helpers.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/history_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/promocodes_history_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/reviews_history_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/online_movies_history_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/history_filter_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_app_bar.dart';
import 'package:kinolive_mobile/presentation/widgets/profile/history/history_filter_bar.dart';

enum HistoryTab { movies, reviews, promocodes }

class TicketsHistoryScreen extends HookConsumerWidget {
  const TicketsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedTab = useState<HistoryTab>(HistoryTab.movies);
    final searchOpen = useState(false);
    final filtersOpen = useState(false);
    final filterState = ref.watch(historyFilterVmProvider);
    final controller = useTextEditingController(text: filterState.query);

    useEffect(() {
      Future.microtask(() {
        ref.read(ticketsHistoryVmProvider.notifier).load();
        ref.read(reviewsHistoryVmProvider.notifier).load();
        ref.read(promocodesHistoryVmProvider.notifier).load();
        ref.read(onlineMoviesHistoryVmProvider.notifier).load();
      });
      return null;
    }, const []);

    void resetSearchAndFilters() {
      controller.clear();
      ref.read(historyFilterVmProvider.notifier).clearFilters();
      searchOpen.value = false;
      filtersOpen.value = false;
      FocusScope.of(context).unfocus();
    }

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
      appBar: HistoryAppBar(
        controller: controller,
        searchOpen: searchOpen.value,
        filtersOpen: filtersOpen.value,
        showSearch: selectedTab.value == HistoryTab.movies,
        onToggleSearch: () {
          if (searchOpen.value) {
            controller.clear();
            ref.read(historyFilterVmProvider.notifier).clearQuery();
            filtersOpen.value = false;
            FocusScope.of(context).unfocus();
          }
          searchOpen.value = !searchOpen.value;
        },
        onToggleFilters: () => filtersOpen.value = !filtersOpen.value,
        onClearQuery: () =>
            ref.read(historyFilterVmProvider.notifier).clearQuery(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: (selectedTab.value == HistoryTab.movies &&
                      searchOpen.value &&
                      filtersOpen.value)
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: HistorySegmentedControl(
                  selectedTab: selectedTab.value,
                  onTabChanged: (tab) {
                    selectedTab.value = tab;
                    resetSearchAndFilters();
                  },
                ),
              ),
              secondChild: const HistoryFilterBar(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  switch (selectedTab.value) {
                    case HistoryTab.movies:
                      await ref.read(ticketsHistoryVmProvider.notifier).load();
                      await ref.read(onlineMoviesHistoryVmProvider.notifier).load();
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final ticketsState = ref.watch(ticketsHistoryVmProvider);
    final onlineMoviesState = ref.watch(onlineMoviesHistoryVmProvider);
    final filterState = ref.watch(historyFilterVmProvider);

    final List<Order> historyOrders = ticketsState.orders
        .where(isHistoryOrder)
        .toList()
      ..sort((a, b) {
        final ka = historySortKey(a);
        final kb = historySortKey(b);
        return kb.compareTo(ka);
      });

    List<dynamic> allItems = [
      ...historyOrders,
      ...onlineMoviesState.movies,
    ]..sort((a, b) {
        DateTime getDate(dynamic item) {
          if (item is Order) {
            return historySortKey(item);
          } else {
            return (item as MyOnlineMovie).purchasedAt;
          }
        }
        return getDate(b).compareTo(getDate(a));
      });

    // Apply search filter
    if (filterState.query.isNotEmpty) {
      final query = filterState.query.toLowerCase().trim();
      allItems = allItems.where((item) {
        String title;
        if (item is Order) {
          title = (item.movieTitle ?? 'Movie #${item.movieId}').toLowerCase();
        } else {
          title = (item as MyOnlineMovie).title.toLowerCase();
        }
        return title.contains(query);
      }).toList();
    }

    // Apply category filter
    if (filterState.selectedCategory != HistoryFilterCategory.all) {
      allItems = allItems.where((item) {
        switch (filterState.selectedCategory) {
          case HistoryFilterCategory.online:
            return item is MyOnlineMovie;
          case HistoryFilterCategory.paid:
            return item is Order && item.status == OrderStatus.paid;
          case HistoryFilterCategory.refunded:
            return item is Order && item.status == OrderStatus.refunded;
          case HistoryFilterCategory.cancelled:
            return item is Order && item.status == OrderStatus.cancelled;
          default:
            return true;
        }
      }).toList();
    }

    Future<void> reload() async {
      await ref.read(ticketsHistoryVmProvider.notifier).load();
      await ref.read(onlineMoviesHistoryVmProvider.notifier).load();
    }

    Widget body;

    final isLoading = ticketsState.isLoading || onlineMoviesState.isLoading;
    final hasError = ticketsState.hasError || onlineMoviesState.hasError;
    final errorMessage = ticketsState.error ?? onlineMoviesState.error;

    final hasActiveFilters = filterState.hasActiveFilters;

    if (isLoading && allItems.isEmpty && !hasActiveFilters) {
      body = const Center(child: CircularProgressIndicator());
    } else if (hasError && allItems.isEmpty && !hasActiveFilters) {
      body = HistoryErrorView(
        message: errorMessage ?? 'Error loading history',
        onRetry: reload,
      );
    } else if (allItems.isEmpty && !hasActiveFilters) {
      body = HistoryEmptyView(onRefresh: reload);
    } else if (allItems.isEmpty && hasActiveFilters) {
      body = Center(
        child: Text(
          'Nothing found',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: allItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = allItems[index];
          if (item is Order) {
            return HistoryTicketListItem(
              order: item,
              onViewDetails: () {
                context.pushNamed(
                  ticketDetailsName,
                  pathParameters: {'orderId': item.id},
                );
              },
              onWriteReview: () {
                context.pushNamed(
                  writeReviewName,
                  extra: item,
                );
              },
            );
          } else {
            final onlineMovie = item as MyOnlineMovie;
            return HistoryOnlineMovieListItem(
              movie: onlineMovie,
              onViewDetails: () {
                context.pushNamed(
                  watchOnlineName,
                  pathParameters: {'movieId': onlineMovie.movieId.toString()},
                );
              },
              onWriteReview: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WriteReviewScreen.fromOnlineMovie(onlineMovie),
                  ),
                );
              },
            );
          }
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
        DateTime getSortDate(Promocode p) {
          if (p.usedAt != null) {
            return p.usedAt!;
          }
          if (p.status == PromocodeStatus.expired) {
            return p.expiresAt;
          }
          return p.createdAt;
        }
        
        final dateA = getSortDate(a);
        final dateB = getSortDate(b);
        return dateB.compareTo(dateA);
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
