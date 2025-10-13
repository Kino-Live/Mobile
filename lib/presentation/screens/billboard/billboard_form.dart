import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';

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
    final isLoading = state.isLoading;

    Widget content() {
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

      final List<Movie> movies = state.movies;

      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          _SectionHeader(
            title: 'Now Showing',
            onSeeMore: () {},
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 350,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final m = movies[i];
                return _PosterCard(
                  title: m.title,
                  rating: m.rating,
                  imageUrl: m.posterUrl,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    return Stack(
      children: [
        content(),
        AnimatedOpacity(
          opacity: isLoading ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: IgnorePointer(
            ignoring: !isLoading,
            child: Container(
              color: Colors.black.withAlpha(51),
              child: const Center(child: CircularProgressIndicator()),
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

class _PosterCard extends StatelessWidget {
  const _PosterCard({
    required this.title,
    required this.rating,
    required this.imageUrl,
  });

  final String title;
  final double rating;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '$rating/10 IMDb',
                style: textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
