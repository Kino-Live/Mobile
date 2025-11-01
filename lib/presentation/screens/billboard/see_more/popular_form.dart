import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/see_more/movie_grid_tile.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';
import 'package:kinolive_mobile/presentation/widgets/general/retry_view.dart';

class PopularForm extends HookConsumerWidget {
  const PopularForm({super.key, required this.onRefresh});
  final Future<void> Function() onRefresh;

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
    final movies = state.movies;
    final popularMovies = [...movies]..sort((a, b) => b.rating.compareTo(a.rating));

    const paddingH = 16.0;
    const crossSpacing = 12.0;
    const crossAxisCount = 2;
    final gridWidth = MediaQuery.of(context).size.width - paddingH * 2;
    final tileWidth =
        (gridWidth - crossSpacing * (crossAxisCount - 1)) / crossAxisCount;

    final s = MediaQuery.of(context).textScaler;
    final titleFs = s.scale(textTheme.bodyLarge?.fontSize ?? 16.0);
    final titleLH = (textTheme.bodyLarge?.height ?? 1.2);
    final ratingFs = s.scale(textTheme.bodySmall?.fontSize ?? 12.0);
    final ratingLH = (textTheme.bodySmall?.height ?? 1.2);
    final cardHeight =
        tileWidth * 1.5 + 8 + titleFs * titleLH * 2 + 4 + ratingFs * ratingLH + 6;

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
            child: RetryView(
              message: state.error ?? 'Error loading movies',
              onRetry: onRefresh,
            ),
          ),
        )
      else if (state.isEmpty)
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
        else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: crossSpacing,
                  mainAxisSpacing: 12,
                  mainAxisExtent: cardHeight,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, i) {
                    final Movie m = popularMovies[i];
                    return MovieGridTile(
                      id: m.id,
                      title: m.title,
                      imageUrl: m.posterUrl,
                      rating: m.rating,
                      onTap: () => context.pushNamed(
                        movieDetailsName,
                        pathParameters: {'id': m.id.toString()},
                      ),
                    );
                  },
                  childCount: popularMovies.length,
                ),
              ),
            ),
          ],
    ];

    return InstantRefreshScrollView(
      slivers: slivers,
      onRefresh: onRefresh,
    );
  }
}
