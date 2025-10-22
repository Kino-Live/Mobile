import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';

class BillboardForm extends HookConsumerWidget {
  const BillboardForm({super.key});

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

    if (state.isLoading && state.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.hasError && state.isEmpty) {
      return Center(
        child: Text(
          state.error ?? 'Error',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
        ),
      );
    }
    if (state.isEmpty) {
      return Center(
        child: Text(
          'No movies yet',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    final movies = state.movies;

    // --- NOW SHOWING
    final visibleNow = movies.take(4).toList();

    // --- POPULAR
    //TODO: It must be at the server (or in another file)
    final popularMovies = [...movies]..sort((a, b) => b.rating.compareTo(a.rating));
    final visiblePopular = popularMovies.take(6).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
        // --- NOW SHOWING
        _SectionHeader(
          title: 'Now Showing',
          onSeeMore: () {
            context.push(seeMoreNowShowingPath);
          },
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
              return _PosterCard(
                id: m.id,
                title: m.title,
                rating: m.rating,
                imageUrl: m.posterUrl,
                onTap: () => context.pushNamed(
                  movieDetailsName,
                  pathParameters: {'id': m.id.toString()},
                  extra: {'heroPrefix': 'now'},
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // --- POPULAR
        _SectionHeader(
          title: 'Popular',
          onSeeMore: () {
            //TODO: Need to add Page
            context.push(seeMorePopularPath);
          },
        ),
        const SizedBox(height: 12),
        ...visiblePopular.map(
              (m) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _PopularTile(
              id: m.id,
              title: m.title,
              rating: m.rating,
              runtime: m.duration,
              tags: m.genres,
              imageUrl: m.posterUrl,
              onTap: () => context.pushNamed(
                movieDetailsName,
                pathParameters: {'id': m.id.toString()},
                extra: {'heroPrefix': 'popular'},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeMore});

  final String title;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: onSeeMore,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: const StadiumBorder(),
            side: BorderSide(color: colorScheme.onSurfaceVariant),
            foregroundColor: colorScheme.onSurfaceVariant,
            textStyle: textTheme.labelLarge,
          ),
          child: const Text('See more'),
        ),
      ],
    );
  }
}

class _PosterCard extends StatefulWidget {
  const _PosterCard({
    required this.id,
    required this.title,
    required this.rating,
    required this.imageUrl,
    this.onTap,
  });

  final int id;
  final String title;
  final double rating;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  State<_PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends State<_PosterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'now_poster_${widget.id}',
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      color: _pressed
                          ? Colors.black.withOpacity(0.25)
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${widget.rating}/10 IMDb',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularTile extends StatelessWidget {
  const _PopularTile({
    required this.id,
    required this.title,
    required this.rating,
    required this.runtime,
    required this.tags,
    required this.imageUrl,
    this.onTap,
  });

  final int id;
  final String title;
  final double rating;
  final String runtime;
  final List<String> tags;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // === POSTER ===
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 100,
                    child: Hero(
                      tag: 'popular_poster_${id}',
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // === RIGHT SIDE (INFO) ===
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- Title ---
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // --- Rating ---
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 18, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '$rating/10 IMDb',
                            style: tt.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // --- Genres ---
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          for (var i = 0; i < tags.length && i < 3; i++)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                tags[i],
                                style: tt.labelSmall?.copyWith(
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                            ),
                          if (tags.length > 3)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '+${tags.length - 3}',
                                style: tt.labelSmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // --- Runtime ---
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule_rounded,
                              size: 18, color: cs.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(
                            runtime,
                            style: tt.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
