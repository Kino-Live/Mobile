import 'package:flutter/material.dart';

class BillboardForm extends StatefulWidget {
  const BillboardForm({super.key});

  @override
  State<BillboardForm> createState() => _BillboardFormState();
}

class _BillboardFormState extends State<BillboardForm> {
  // demo data
  final nowShowing = [
    (
    title: 'Spiderman: No Way Home',
    poster: 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
    rating: 9.1,
    ),
    (
    title: 'Eternals',
    poster: 'https://image.tmdb.org/t/p/w500/b6qUu00iIIkXX13szFy7d0CyNcg.jpg',
    rating: 9.5,
    ),
    (
    title: 'Shang-Chi',
    poster: 'https://image.tmdb.org/t/p/w500/1BIoJGKbXjdFDAqUEiA2VHqkK1Z.jpg',
    rating: 8.1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
        // NOW SHOWING
        _SectionHeader(
          title: 'Now Showing',
          onSeeMore: () {},
        ),
        const SizedBox(height: 12),
        SizedBox(
          //ToDo: Сhange the height depending on the card height
          height: 350,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: nowShowing.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final m = nowShowing[i];
              return _PosterCard(
                title: m.title,
                rating: m.rating,
                imageUrl: m.poster,
              );
            },
          ),
        ),

        const SizedBox(height: 24),
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
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
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
          // Poster
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 8),

          //ToDo: (Maximum size of 3 lines of all)
          //ToDo: Change the behavior for large text (so that it scrolls to the right and back automatically)
          // Name
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          // Rate
          Row(
            children: [
              Icon(Icons.star_rounded, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '$rating/10 IMDb',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}