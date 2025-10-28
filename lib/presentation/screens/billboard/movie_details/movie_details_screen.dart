import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/movie_details/movie_details_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/movie_details_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  const MovieDetailsScreen({super.key, required this.id});
  final int id;

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieDetailsVmProvider(widget.id).notifier)
          .init(widget.id, force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(
      movieDetailsVmProvider(widget.id)
          .select((s) => s.status),
    );
    final movie = ref.watch(
      movieDetailsVmProvider(widget.id)
          .select((s) => s.movie),
    );
    final error = ref.watch(
      movieDetailsVmProvider(widget.id)
          .select((s) => s.error),
    );

    if (error != null && error.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error, textAlign: TextAlign.center)),
        );
        ref.read(movieDetailsVmProvider(widget.id).notifier).clearError();
      });
    }

    Future<void> _retry() async {
      await ref
        .read(movieDetailsVmProvider(widget.id).notifier)
        .init(widget.id, force: true);
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: status == MovieDetailsStatus.loading,
          child: Builder(
            builder: (_) {
              switch (status) {
                case MovieDetailsStatus.loaded:
                  return MovieDetailsForm(
                    movie: movie!,
                    onPlayTrailer: _openTrailer,
                  );
                case MovieDetailsStatus.error:
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Loading error'),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _retry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                case MovieDetailsStatus.loading:
                  return const SizedBox.shrink();
                case MovieDetailsStatus.idle:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openTrailer(Movie m) async {
    final uri = Uri.tryParse(m.trailerUrl);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open trailer')),
      );
    }
  }
}
