import 'package:flutter/material.dart';
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
                        _SectionTitle('Select Day', color: colorScheme.onSurface, textTheme: textTheme),
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
                        const SizedBox(height: 30),
                        _SectionTitle('Select Time', color: colorScheme.onSurface, textTheme: textTheme),
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
                        const SizedBox(height: 30),
                        _SectionTitle('Select Quality', color: colorScheme.onSurface, textTheme: textTheme),
                        const SizedBox(height: 12),
                        _QualityChips(
                          selectedQuality: data.quality,
                          onSelect2D: data.is2DAvailableForSelectedTime ? actions.onSet2D : () {},
                          onSelect3D: data.is3DAvailableForSelectedTime ? actions.onSet3D : () {},
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {required this.textTheme, required this.color});
  final String text;
  final Color color;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: textTheme.titleMedium,
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

  Widget _circleIcon(IconData icon, VoidCallback onTap, ColorScheme colors) => InkResponse(
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

class _PillChip extends StatelessWidget {
  const _PillChip({
    required this.child,
    required this.onTap,
    required this.selected,
    required this.colors,
    this.height = 56,
    this.minWidth = 64,
    this.horizontalPadding = 16,
    this.radius = 16,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool selected;
  final ColorScheme colors;
  final double height;
  final double minWidth;
  final double horizontalPadding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? colors.primary : colors.surfaceContainerHigh;
    final borderRadius = BorderRadius.circular(radius);

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height, minWidth: minWidth),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius),
          child: Center(child: child),
        ),
      ),
    );
  }
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
    height: 64,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: days.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (ctx, i) {
        final d = DateTime.tryParse(days[i]);
        final month = d != null ? _monthShort(d) : '';
        final day = d != null ? '${d.day}' : days[i];
        final sel = i == selectedIndex;

        final topColor = sel ? colorScheme.onPrimaryContainer : colorScheme.onSurface;
        final mainColor = sel ? colorScheme.onPrimaryContainer : colorScheme.onSurface;

        return _PillChip(
          selected: sel,
          colors: colorScheme,
          height: 56,
          minWidth: 68,
          radius: 14,
          onTap: () => onSelect(i),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(month, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, height: 1.0, color: topColor)),
              const SizedBox(height: 2),
              Text(day, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.0, color: mainColor)),
            ],
          ),
        );
      },
    ),
  );

  String _monthShort(DateTime d) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1];
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
    height: 54,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: isoList.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (ctx, i) {
        final dt = DateTime.tryParse(isoList[i])?.toLocal();
        final label = dt == null
            ? isoList[i]
            : '${(dt.hour % 12 == 0 ? 12 : dt.hour % 12)}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'pm' : 'am'}';

        final sel = i == selectedIndex;
        final fg = sel ? colorScheme.onPrimaryContainer : colorScheme.onSurface;

        return _PillChip(
          selected: sel,
          colors: colorScheme,
          height: 48,
          minWidth: 78,
          radius: 14,
          onTap: () => onSelect(i),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.0, color: fg),
          ),
        );
      },
    ),
  );
}

class _QualityChips extends StatelessWidget {
  const _QualityChips({
    required this.selectedQuality,
    required this.onSelect2D,
    required this.onSelect3D,
    required this.colorScheme,
    this.is2DAvailable = true,
    this.is3DAvailable = true,
  });

  final String selectedQuality;
  final VoidCallback onSelect2D;
  final VoidCallback onSelect3D;
  final ColorScheme colorScheme;
  final bool is2DAvailable;
  final bool is3DAvailable;

  @override
  Widget build(BuildContext context) {
    final is2D = selectedQuality == '2D';
    final is3D = selectedQuality == '3D';

    Color fg(bool selected, bool available) {
      if (selected) return colorScheme.onPrimaryContainer;
      if (!available) return colorScheme.onSurface.withOpacity(0.4);
      return colorScheme.onSurface;
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillChip(
            selected: is2D,
            colors: colorScheme,
            height: 46,
            minWidth: 72,
            radius: 14,
            horizontalPadding: 20,
            onTap: is2DAvailable ? onSelect2D : () {},
            child: Text(
              '2D',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.0, color: fg(is2D, is2DAvailable)),
            ),
          ),
          const SizedBox(width: 12),
          _PillChip(
            selected: is3D,
            colors: colorScheme,
            height: 46,
            minWidth: 72,
            radius: 14,
            horizontalPadding: 20,
            onTap: is3DAvailable ? onSelect3D : () {},
            child: Text(
              '3D',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.0, color: fg(is3D, is3DAvailable)),
            ),
          ),
        ],
      ),
    );
  }
}
