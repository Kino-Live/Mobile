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
    final sched = ref.watch(scheduleVmProvider(widget.id));
    final vm    = ref.read(scheduleVmProvider(widget.id).notifier);

    final movie = ref.watch(movieDetailsVmProvider(widget.id).select((s) => s.movie));
    final mdSt  = ref.watch(movieDetailsVmProvider(widget.id).select((s) => s.status));

    final isLoading =
        sched.status == ScheduleStatus.loading || mdSt == MovieDetailsStatus.loading;

    void showErr(String? e) {
      if (e == null || e.isEmpty) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e, textAlign: TextAlign.center)),
        );
        ref.read(scheduleVmProvider(widget.id).notifier).clearError();
      });
    }
    showErr(sched.error);

    Future<void> retry() async {
      await ref.read(scheduleVmProvider(widget.id).notifier).init(widget.id, force: true);
      await ref.read(movieDetailsVmProvider(widget.id).notifier).init(widget.id, force: true);
    }

    if (sched.status == ScheduleStatus.error) {
      return Scaffold(body: SafeArea(child: RetryView(onRetry: retry)));
    }

    final data = ScheduleFormData(
      title: movie?.title ?? '',
      posterUrl: movie?.posterUrl ?? '',
      availableDays: sched.availableDays,
      selectedDayIndex: sched.selectedDayIndex,
      quality: sched.quality,
      timesIso: sched.times.map((t) => t.startIso).toList(),
      selectedTimeIndex: sched.selectedTimeIndex,
    );

    final actions = ScheduleFormActions(
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
        final st = sched.selectedShowtime?.id;
        if (st == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select time')),
          );
          return;
        }
        context.pushNamed('select_seat', pathParameters: {'showtimeId': st});
      },
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: isLoading,
          child: ScheduleForm(
            data: data,
            actions: actions,
            onRefresh: retry,
          ),
        ),
      ),
    );
  }
}
