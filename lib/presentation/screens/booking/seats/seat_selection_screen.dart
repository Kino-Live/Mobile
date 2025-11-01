import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/screens/booking/seats/seat_selection_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/booking/seat_selection_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/movie_details_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';
import 'package:kinolive_mobile/presentation/widgets/general/retry_view.dart';

class SeatSelectionScreen extends ConsumerStatefulWidget {
  const SeatSelectionScreen({
    super.key,
    required this.movieId,
    required this.showtimeId,
  });

  final int movieId;
  final String showtimeId;

  @override
  ConsumerState<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {
  late final SeatSelectionArgs _args;

  @override
  void initState() {
    super.initState();
    _args = SeatSelectionArgs(movieId: widget.movieId, showtimeId: widget.showtimeId);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(seatSelectionVmProvider(_args).notifier).init(
        movieId: widget.movieId,
        showtimeId: widget.showtimeId,
        force: true,
      );
      await ref.read(movieDetailsVmProvider(widget.movieId).notifier).init(
        widget.movieId,
        force: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final seatState = ref.watch(seatSelectionVmProvider(_args));
    final seatVm = ref.read(seatSelectionVmProvider(_args).notifier);

    final movie = ref.watch(movieDetailsVmProvider(widget.movieId).select((s) => s.movie));
    final movieSt = ref.watch(movieDetailsVmProvider(widget.movieId).select((s) => s.status));

    final isLoading = seatState.isLoading || movieSt == MovieDetailsStatus.loading;

    final error = seatState.error;
    if (error != null && error.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error, textAlign: TextAlign.center)),
        );
        ref.read(seatSelectionVmProvider(_args).notifier).clearError();
      });
    }

    Future<void> retry() async {
      await ref.read(seatSelectionVmProvider(_args).notifier).init(
        movieId: widget.movieId,
        showtimeId: widget.showtimeId,
        force: true,
      );
      await ref.read(movieDetailsVmProvider(widget.movieId).notifier).init(
        widget.movieId,
        force: true,
      );
    }

    if (seatState.hasError || movieSt == MovieDetailsStatus.error) {
      return Scaffold(body: SafeArea(child: RetryView(onRetry: retry)));
    }

    final hall = seatState.hallInfo?.hall;
    final cinema = seatState.hallInfo?.cinema;

    final data = SeatSelectionFormData(
      title: movie?.title ?? 'Movie',
      posterUrl: movie?.posterUrl ?? '',
      cinemaName: cinema?.name ?? '',
      cinemaAddr: cinema == null ? '' : '${cinema.city}, ${cinema.address}',
      hallName: hall?.name ?? '',
      dateText: seatState.dateText,
      timeRange: seatState.timeRange,
      is3D: seatState.is3D,
      rows: hall?.rows ?? const [],
      selected: seatState.selected,
      selectedCount: seatState.selectedCount,
      movieId: seatState.movieId,
      showtimeId: seatState.showtimeId,
      date: seatState.date,
      startIso: seatState.startIso,
      endIso: seatState.endIso,
      quality: seatState.quality,
    );

    final actions = SeatSelectionFormActions(
      onBack: () => context.pop(),
      onRefresh: retry,
      onToggleSeat: seatVm.toggleSeat,
      onClear: seatVm.clearSelection,
      onContinue: () {
        final selected = seatVm.getSelectedSeats();
        final msg = [
          // 'movieId: ${data.movieId}',
          // 'showtimeId: ${data.showtimeId}',
          // 'date: ${data.date}',
          // 'start: ${data.startIso}',
          // 'end: ${data.endIso}',
          // 'quality: ${data.quality}',
          'selected seats: ${selected.join(", ")}',
        ].join('\n');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      },
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: isLoading,
          child: Builder(
            builder: (_) {
              if (seatState.isLoaded && movieSt == MovieDetailsStatus.loaded) {
                return SeatSelectionForm(data: data, actions: actions);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
