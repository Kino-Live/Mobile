import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class ScheduleFormData {
  final String title;
  final String posterUrl;
  final List<String> availableDays;
  final int selectedDayIndex;
  final String quality; // "2D" | "3D"
  final List<String> timesIso;
  final int selectedTimeIndex;

  const ScheduleFormData({
    required this.title,
    required this.posterUrl,
    required this.availableDays,
    required this.selectedDayIndex,
    required this.quality,
    required this.timesIso,
    required this.selectedTimeIndex,
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
      color: colorScheme.surface, // общий фон
      child: InstantRefreshScrollView(
        onRefresh: onRefresh,
        slivers: [
          // --- Верхний постер ---
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
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.black26),
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
                            colorScheme.surface.withOpacity(0.9),
                            colorScheme.surface,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Название фильма ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Center(
                child: Text(
                  data.title,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // --- Основная панель ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                        _SectionTitle(
                          'Select Day',
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(height: 12),
                        _ArrowStrip(
                          onPrev: actions.onPrevDay,
                          onNext: actions.onNextDay,
                          child: _DayChips(
                            days: data.availableDays,
                            selectedIndex: data.selectedDayIndex,
                            onSelect: actions.onSelectDay,
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _SectionTitle(
                          'Select Time',
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(height: 12),
                        _ArrowStrip(
                          onPrev: actions.onPrevTime,
                          onNext: actions.onNextTime,
                          child: _TimeChips(
                            isoList: data.timesIso,
                            selectedIndex: data.selectedTimeIndex,
                            onSelect: actions.onSelectTime,
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _SectionTitle(
                          'Select Quality',
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('2D'),
                                selected: data.quality == '2D',
                                onSelected: (_) => actions.onSet2D(),
                                selectedColor: colorScheme.primary,
                                backgroundColor: colorScheme.surfaceContainer,
                                labelStyle: TextStyle(
                                  color: data.quality == '2D'
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('3D'),
                                selected: data.quality == '3D',
                                onSelected: (_) => actions.onSet3D(),
                                selectedColor: colorScheme.primary,
                                backgroundColor: colorScheme.surfaceContainer,
                                labelStyle: TextStyle(
                                  color: data.quality == '3D'
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Кнопка Continue ---
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
    ),
  );
}

class _ArrowStrip extends StatelessWidget {
  const _ArrowStrip({
    required this.child,
    required this.onPrev,
    required this.onNext,
  });

  final Widget child;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _circleIcon(Icons.chevron_left, onPrev, colorScheme),
        const SizedBox(width: 8),
        Expanded(child: child),
        const SizedBox(width: 8),
        _circleIcon(Icons.chevron_right, onNext, colorScheme),
      ],
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap, ColorScheme colors) =>
      InkResponse(
        onTap: onTap,
        radius: 22,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceContainer,
          ),
          child: Icon(icon, size: 20, color: colors.onSurface),
        ),
      );
}

class _DayChips extends StatelessWidget {
  const _DayChips({
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
    required this.colorScheme,
  });

  final List<String> days;
  final int selectedIndex;
  final void Function(int) onSelect;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: days.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (ctx, i) {
        final d = DateTime.tryParse(days[i]);
        final top = d != null ? _monthShort(d) : '';
        final bottom = d != null ? '${d.day}' : days[i];
        final selected = i == selectedIndex;

        return ChoiceChip(
          selected: selected,
          onSelected: (_) => onSelect(i),
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(top, style: const TextStyle(fontSize: 12)),
              Text(bottom),
            ],
          ),
          backgroundColor: colorScheme.surfaceContainer,
          selectedColor: colorScheme.primary,
          labelStyle: TextStyle(
            color: selected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
    ),
  );

  String _monthShort(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return m[d.month - 1];
  }
}

class _TimeChips extends StatelessWidget {
  const _TimeChips({
    required this.isoList,
    required this.selectedIndex,
    required this.onSelect,
    required this.colorScheme,
  });

  final List<String> isoList;
  final int selectedIndex;
  final void Function(int) onSelect;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: isoList.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (ctx, i) {
        final dt = DateTime.tryParse(isoList[i])?.toLocal();
        final label = (dt == null)
            ? isoList[i]
            : '${(dt.hour % 12 == 0 ? 12 : dt.hour % 12)}:${dt.minute.toString().padLeft(2, '0')}'
            ' ${dt.hour >= 12 ? 'pm' : 'am'}';

        final selected = i == selectedIndex;

        return ChoiceChip(
          selected: selected,
          onSelected: (_) => onSelect(i),
          label: Text(
            label,
            style: TextStyle(
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: colorScheme.surfaceContainer,
          selectedColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
    ),
  );
}
