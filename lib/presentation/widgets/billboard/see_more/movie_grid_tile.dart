import 'package:flutter/material.dart';

class MovieGridTile extends StatefulWidget {
  const MovieGridTile({
    super.key,
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
  State<MovieGridTile> createState() => _MovieGridTileState();
}

class _MovieGridTileState extends State<MovieGridTile> {
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
