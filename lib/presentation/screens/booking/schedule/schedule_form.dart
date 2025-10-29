import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/arrow_strip.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/day_chips.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/quality_chips.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/section_title.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/time_chips.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class ScheduleFormData {
  final String title;
  final String posterUrl;
  final List<String> availableDays;
  final int selectedDayIndex;
  final String quality;
  final List<String> timesIso;
  final int selectedTimeIndex;
  final bool is2DAvailableForSelectedTime;
  final bool is3DAvailableForSelectedTime;

  const ScheduleFormData({
    required this.title,
    required this.posterUrl,
    required this.availableDays,
    required this.selectedDayIndex,
    required this.quality,
    required this.timesIso,
    required this.selectedTimeIndex,
    this.is2DAvailableForSelectedTime = true,
    this.is3DAvailableForSelectedTime = true,
  });
}

class ScheduleFormActions {
  final VoidCallback onBack;
  final VoidCallback onPrevDay;
  final VoidCallback onNextDay;
  final void Function(int) onSelectDay;
  final VoidCallback onPrevTime;
  final VoidCallback onNextTime;
  final void Function(int) onSelectTime;
  final VoidCallback onSet2D;
  final VoidCallback onSet3D;
  final VoidCallback onContinue;

  const ScheduleFormActions({
    required this.onBack,
    required this.onPrevDay,
    required this.onNextDay,
    required this.onSelectDay,
    required this.onPrevTime,
    required this.onNextTime,
    required this.onSelectTime,
    required this.onSet2D,
    required this.onSet3D,
    required this.onContinue,
  });
}

class ScheduleForm extends StatelessWidget {
  const ScheduleForm({
    super.key,
    required this.data,
    required this.actions,
    this.onRefresh,
  });

  final ScheduleFormData data;
  final ScheduleFormActions actions;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surface,
      child: InstantRefreshScrollView(
        onRefresh: onRefresh,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: actions.onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    data.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.black26),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            colorScheme.surface.withOpacity(0.0),
                            colorScheme.surface.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: Colors.black.withOpacity(0.35),
                      child: Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SectionTitle('Select Day', color: colorScheme.onSurface, textTheme: textTheme),
                        const SizedBox(height: 12),
                        ArrowStrip(
                          onPrev: actions.onPrevDay,
                          onNext: actions.onNextDay,
                          child: DayChips(
                            days: data.availableDays,
                            selectedIndex: data.selectedDayIndex,
                            onSelect: actions.onSelectDay,
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SectionTitle('Select Time', color: colorScheme.onSurface, textTheme: textTheme),
                        const SizedBox(height: 12),
                        ArrowStrip(
                          onPrev: actions.onPrevTime,
                          onNext: actions.onNextTime,
                          child: TimeChips(
                            isoList: data.timesIso,
                            selectedIndex: data.selectedTimeIndex,
                            onSelect: actions.onSelectTime,
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SectionTitle('Select Quality', color: colorScheme.onSurface, textTheme: textTheme),
                        const SizedBox(height: 12),
                        // ВАЖНО: передаём реальные обработчики ВСЕГДА, визуально лишь "диммим" недоступность
                        QualityChips(
                          selectedQuality: data.quality,
                          onSelect2D: actions.onSet2D,
                          onSelect3D: actions.onSet3D,
                          colorScheme: colorScheme,
                          is2DAvailable: data.is2DAvailableForSelectedTime,
                          is3DAvailable: data.is3DAvailableForSelectedTime,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Continue',
                    onPressed: actions.onContinue,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    bottomSpacing: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
