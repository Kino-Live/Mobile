import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/see_more/movie_grid_tile.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';

class NowShowingForm extends ConsumerWidget {
  const NowShowingForm({super.key, required this.onRefresh});
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(
      billboardVmProvider.select((s) => s.movies),
    );

    return InstantRefreshScrollView(
      onRefresh: onRefresh,
      slivers: [
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
                final Movie m = movies[i];
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
              childCount: movies.length,
            ),
          ),
        ),
      ],
    );
  }
}
