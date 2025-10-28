import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router_path.dart';
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 350,
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
