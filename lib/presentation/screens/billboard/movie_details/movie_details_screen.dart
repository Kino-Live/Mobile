import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/presentation/viewmodels/movie_details_vm.dart';
import 'package:kinolive_mobile/domain/entities/movie_details.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  const MovieDetailsScreen({super.key, required this.id});
  final int id;

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieDetailsVmProvider.notifier).init(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieDetailsVmProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: switch (state.status) {
          MovieDetailsStatus.loading => const _LoadingView(),
          MovieDetailsStatus.error => Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error!, textAlign: TextAlign.center,)),
                  );
                }
              });
              return const Center(child: Text('Loading error'));
            },
          ),
          MovieDetailsStatus.loaded => _Content(movie: state.movie!, onPlayTrailer: _openTrailer),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Future<void> _openTrailer(MovieDetails m) async {
    final uri = Uri.tryParse(m.trailerUrl);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open trailer')),
        );
      }
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _Content extends StatefulWidget {
  const _Content({required this.movie, required this.onPlayTrailer});
  final MovieDetails movie;
  final Future<void> Function(MovieDetails) onPlayTrailer;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final m = widget.movie;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          expandedHeight: 320,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Poster
                Hero(
                  tag: 'poster_${m.id}',
                  child: Image.network(
                    m.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.black26),
                  ),
                ),
                // Gradient bottom fade
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
                // Play button
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => widget.onPlayTrailer(m),
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
                        m.title,
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
                    Text('${m.rating.toStringAsFixed(1)}/10 IMDb',
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),

                const SizedBox(height: 12),
                // Genres chips
                Wrap(
                  spacing: 8,
                  runSpacing: -8,
                  children: m.genres
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
                // Info row (Length, Language, Rating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoPill(title: 'Length', value: m.duration),
                    _InfoPill(title: 'Language', value: m.language),
                    _InfoPill(title: 'Rating', value: m.ageRestrictions),
                  ],
                ),

                const SizedBox(height: 20),
                const Text('Description',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _ExpandableText(text: m.description),

                const SizedBox(height: 25),
                Row(
                  children: [
                    const Text('Cast',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (m.cast.length > 5)
                      TextButton(
                        onPressed: () {},
                        child: const Text('More', style: TextStyle(color: Colors.white70)),
                      ),
                  ],
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      final name = m.cast[i];
                      return _CastCard(name: name);
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: m.cast.length,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((e) => e.characters.first).join()
        : '?';
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF23262B),
          child: Text(initials, style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 84,
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text, this.trimLines = 3});
  final String text;
  final int trimLines;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = const TextStyle(color: Colors.white70, height: 1.35);
    final text = Text(
      widget.text,
      maxLines: _expanded ? null : widget.trimLines,
      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
      style: style,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text,
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Collapse' : 'Read more',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
