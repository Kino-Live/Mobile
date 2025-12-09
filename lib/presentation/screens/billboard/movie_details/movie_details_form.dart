import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/presentation/viewmodels/movie_reviews_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/movie_details/cast_card.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/movie_details/expandable_text.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/movie_details/info_pill.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/movie_details/reviews_section.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MovieDetailsForm extends HookConsumerWidget {
  const MovieDetailsForm({
    super.key,
    required this.movie,
    required this.onPlayTrailer,
    this.onRefresh,
  });

  final Movie movie;
  final Future<void> Function(Movie) onPlayTrailer;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final reviewsState = ref.watch(movieReviewsVmProvider(movie.id));

    useEffect(() {
      Future.microtask(() {
        ref.read(movieReviewsVmProvider(movie.id).notifier).load(movie.id);
      });
      return null;
    }, [movie.id]);

    ref.listen(movieReviewsVmProvider(movie.id), (prev, next) {
      if (next.hasError && next.error != null) {
        debugPrint('Error loading reviews: ${next.error}');
      }
    });

    return InstantRefreshScrollView(
      onRefresh: () async {
        await onRefresh?.call();
        await ref.read(movieReviewsVmProvider(movie.id).notifier).load(movie.id);
      },
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          expandedHeight: 320,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // === Poster ===
                Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.black26),
                ),

                // === Gradient bottom fade ===
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xAA0E0F12),
                          Color(0xFF0E0F12),
                        ],
                      ),
                    ),
                  ),
                ),

                // === Play button ===
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => onPlayTrailer(movie),
                    borderRadius: BorderRadius.circular(48),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.play_arrow, size: 36, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // === Body content ===
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text('${movie.rating.toStringAsFixed(1)}/10 IMDb',
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),

                const SizedBox(height: 12),
                // Genres
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: movie.genres
                      .map(
                        (g) => Chip(
                      label: Text(g),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: const Color(0xFF1B1D22),
                      labelStyle: const TextStyle(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  )
                      .toList(),
                ),

                const SizedBox(height: 16),
                // Info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoPill(title: 'Length', value: movie.duration),
                    InfoPill(title: 'Language', value: movie.language),
                    InfoPill(title: 'Rating', value: movie.ageRestrictions),
                  ],
                ),

                const SizedBox(height: 20),
                const Text('Description',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ExpandableText(text: movie.description),

                const SizedBox(height: 25),
                Row(
                  children: [
                    const Text('Cast',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                  ],
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      final name = movie.cast[i];
                      return CastCard(name: name);
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: movie.cast.length,
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pushNamed(
                          scheduleName,
                          pathParameters: {'id': movie.id.toString()},
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Buy tickets'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Watch online'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                ReviewsSection(
                  movieId: movie.id,
                  reviews: reviewsState.reviews,
                  isLoading: reviewsState.isLoading,
                  error: reviewsState.error,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
