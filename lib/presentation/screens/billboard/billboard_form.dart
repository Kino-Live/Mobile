import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/popular_tile.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/poster_card.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/section_header.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';

class BillboardForm extends HookConsumerWidget {
  const BillboardForm({super.key, this.onRefresh});

  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      Future.microtask(() => ref.read(billboardVmProvider.notifier).load());
      return null;
    }, const []);

    ref.listen(billboardVmProvider, (prev, next) {
      if (next.status == BillboardStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
        ref.read(billboardVmProvider.notifier).clearError();
      }
    });

    final state = ref.watch(billboardVmProvider);

    final movies = state.filteredMovies;
    final hasActiveFilters = state.query.isNotEmpty || state.selectedGenres.isNotEmpty || state.minRating > 0;

    //TODO: Move this block?
    final visibleNow = movies.take(4).toList();
    final popular = [...movies]..sort((a, b) => b.rating.compareTo(a.rating));
    final visiblePopular = popular.take(6).toList();

    Future<void> defaultRefresh() => ref.read(billboardVmProvider.notifier).load();

    final slivers = <Widget>[
      if (state.isLoading && state.isEmpty)
        const SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox.shrink(),
        )
      else if (state.hasError && state.isEmpty)
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              'Error loading movies',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        )
      else if (state.isEmpty && movies.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No movies yet',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
      else if (movies.isEmpty && hasActiveFilters)
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              'Nothing found',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        )
      else ...[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- NOW SHOWING ---
                SectionHeader(
                  title: 'Now Showing',
                  actionText: 'See more',
                  onAction: () => context.push(seeMoreNowShowingPath),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 350,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: visibleNow.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, i) {
                      final m = visibleNow[i];
                      return PosterCard(
                        title: m.title,
                        rating: m.rating,
                        imageUrl: m.posterUrl,
                        width: 170,
                        onTap: () => context.pushNamed(
                          movieDetailsName,
                          pathParameters: {'id': m.id.toString()},
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                  // --- POPULAR ---
                  SectionHeader(
                    title: 'Popular',
                    actionText: 'See more',
                    onAction: () {
                      // TODO: add Popular page
                    },
                  ),
                  const SizedBox(height: 12),
                  ...visiblePopular.map(
                    (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PopularTile(
                      title: m.title,
                      rating: m.rating,
                      runtime: m.duration,
                      tags: m.genres,
                      imageUrl: m.posterUrl,
                      onTap: () => context.pushNamed(
                        movieDetailsName,
                        pathParameters: {'id': m.id.toString()},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ];

    return InstantRefreshScrollView(
      slivers: slivers,
      onRefresh: onRefresh ?? defaultRefresh,
    );
  }
}
