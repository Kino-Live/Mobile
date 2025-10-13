import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
            context.push('/billboard/see-more-now-showing');
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
                onTap: () => context.push('/billboard/movie/${m.id}'),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // --- POPULAR
        _SectionHeader(
          title: 'Popular',
          onSeeMore: () {
            context.push('/billboard/see-more-popular');
          },
        ),
        const SizedBox(height: 12),
        ...visiblePopular.map(
              (m) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _PopularTile(
              title: m.title,
              rating: m.rating,
              // runtime: m.runtimeLabel ?? '${m.runtimeMinutes} min',
              // tags: m.genres?.map((g) => g.name).toList() ?? const [],
              runtime: '',
              tags: const <String>[],
              imageUrl: m.posterUrl,
              onTap: () => context.push('/billboard/movie/${m.id}'),
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
                      tag: 'poster_${widget.id}',
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
    required this.title,
    required this.rating,
    required this.runtime,
    required this.tags,
    required this.imageUrl,
    this.onTap,
  });

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 82,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 32),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Row(
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags
                          .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                          Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          t,
                          style: tt.labelLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 18, color: cs.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(runtime,
                            style: tt.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
