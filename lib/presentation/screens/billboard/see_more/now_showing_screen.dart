import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';

class NowShowingScreen extends HookConsumerWidget {
  const NowShowingScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Now Showing',
            style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
      ),
      body: Builder(
        builder: (_) {
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
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          final List<Movie> movies = state.movies;

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 350,
            ),
            itemCount: movies.length,
            itemBuilder: (context, i) {
              final m = movies[i];
              return _MovieGridTile(
                id: m.id,
                title: m.title,
                imageUrl: m.posterUrl,
                rating: m.rating,
                onTap: () => context.pushNamed(movieDetailsName, pathParameters: {'id': m.id.toString()}),
              );
            },
          );
        },
      )
    );
  }
}

class _MovieGridTile extends StatefulWidget {
  const _MovieGridTile({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    this.onTap,
  });

  final int id;
  final String title;
  final String imageUrl;
  final double rating;
  final VoidCallback? onTap;

  @override
  State<_MovieGridTile> createState() => _MovieGridTileState();
}

class _MovieGridTileState extends State<_MovieGridTile> {
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
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 40),
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
    );
  }
}

