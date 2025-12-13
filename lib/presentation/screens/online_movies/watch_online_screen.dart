import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/viewmodels/movie_details_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/billboard/movie_details/info_pill.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';
import 'package:kinolive_mobile/presentation/widgets/general/retry_view.dart';
import 'package:kinolive_mobile/shared/providers/online_movies_providers.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class WatchOnlineScreen extends ConsumerStatefulWidget {
  const WatchOnlineScreen({super.key, required this.movieId});

  final int movieId;

  @override
  ConsumerState<WatchOnlineScreen> createState() => _WatchOnlineScreenState();
}

class _WatchOnlineScreenState extends ConsumerState<WatchOnlineScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    try {
      final repository = ref.read(onlineMoviesRepositoryProvider);
      final watchInfo = await repository.getVideoUrl(widget.movieId);
      
      _videoController = VideoPlayerController.networkUrl(Uri.parse(watchInfo.videoUrl));
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        aspectRatio: _videoController!.value.aspectRatio,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        fullScreenByDefault: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Error loading video',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = error.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _retry() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    await _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(movieDetailsVmProvider(widget.movieId));
    final movie = movieState.movie;

    if (movieState.status == MovieDetailsStatus.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(movieDetailsVmProvider(widget.movieId).notifier).init(widget.movieId);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F12),
      body: LoadingOverlay(
        loading: _isLoading || movieState.isLoading,
        child: _error != null
            ? RetryView(onRetry: _retry)
            : _chewieController != null && movie != null
                ? CustomScrollView(
                    slivers: [
                      // AppBar
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: const Color(0xFF0E0F12),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        elevation: 0,
                      ),

                      // Video Player
                      SliverToBoxAdapter(
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: Chewie(controller: _chewieController!),
                        ),
                      ),

                      // Movie Info
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Rating
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      movie.title,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${movie.rating.toStringAsFixed(1)}/10 IMDb',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
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
                                children: [
                                  InfoPill(title: 'Length', value: movie.duration),
                                  InfoPill(title: 'Language', value: movie.language),
                                  InfoPill(title: 'Rating', value: movie.ageRestrictions),
                                ],
                              ),

                              const SizedBox(height: 20),
                              const Text(
                                'Description',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),

                              if (movie.director.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Director',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.director,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],

                              if (movie.cast.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Cast',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.cast.join(', '),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
