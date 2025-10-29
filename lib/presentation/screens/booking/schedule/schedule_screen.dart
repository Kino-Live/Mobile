import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/booking/schedule/schedule_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/booking/schedule_vm.dart';

import 'package:kinolive_mobile/presentation/viewmodels/movie_details_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';
import 'package:kinolive_mobile/presentation/widgets/general/retry_view.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key, required this.id});
  final int id;

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scheduleVmProvider(widget.id).notifier).init(widget.id, force: true);
      ref.read(movieDetailsVmProvider(widget.id).notifier).init(widget.id, force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleStatus = ref.watch(scheduleVmProvider(widget.id).select((s) => s.status));
    final scheduleError  = ref.watch(scheduleVmProvider(widget.id).select((s) => s.error));
    final scheduleState  = ref.watch(scheduleVmProvider(widget.id));

    final mdStatus = ref.watch(movieDetailsVmProvider(widget.id).select((s) => s.status));
    final movie    = ref.watch(movieDetailsVmProvider(widget.id).select((s) => s.movie));
    final mdError  = ref.watch(movieDetailsVmProvider(widget.id).select((s) => s.error));

    void showError(String? err) {
      if (err == null || err.isEmpty) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err, textAlign: TextAlign.center)),
        );
      });
    }
    showError(scheduleError);
    showError(mdError);

    Future<void> retry() async {
      await ref.read(scheduleVmProvider(widget.id).notifier).init(widget.id, force: true);
      await ref.read(movieDetailsVmProvider(widget.id).notifier).init(widget.id, force: true);
    }

    final vm = ref.read(scheduleVmProvider(widget.id).notifier);
    final title = movie?.title ?? '';
    final poster = movie?.posterUrl ?? '';

    final isLoading = scheduleStatus == ScheduleStatus.loading ||
        mdStatus == MovieDetailsStatus.loading;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: isLoading,
          child: Builder(
            builder: (_) {
              if (scheduleStatus == ScheduleStatus.error) {
                return RetryView(onRetry: retry);
              }

              if (scheduleStatus == ScheduleStatus.loaded) {
                return ScheduleForm(
                  title: title,
                  posterUrl: poster,
                  availableDays: scheduleState.availableDays,
                  selectedDayIndex: scheduleState.selectedDayIndex,
                  quality: scheduleState.quality,
                  times: scheduleState.times.map((t) => t.startIso).toList(),
                  selectedTimeIndex: scheduleState.selectedTimeIndex,

                  onBack: () => context.pop(),
                  onPrevDay: () => vm.shiftDay(-1),
                  onNextDay: () => vm.shiftDay(1),
                  onSelectDay: (i) => vm.selectDay(i),

                  onPrevTime: () => vm.shiftTime(-1),
                  onNextTime: () => vm.shiftTime(1),
                  onSelectTime: (i) => vm.selectTime(i),

                  onSet2D: () => vm.setQuality(false),
                  onSet3D: () => vm.setQuality(true),

                  onContinue: () {
                    final showtimeId = scheduleState.selectedShowtime?.id;
                    if (showtimeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select time')),
                      );
                      return;
                    }
                    // TODO: enter the name of your route of choosing places
                    context.pushNamed('select_seat', pathParameters: {'showtimeId': showtimeId});
                  },
                  onRefresh: retry,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
