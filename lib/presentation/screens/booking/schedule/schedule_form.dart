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
                          child: DayChips(
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
                          child: TimeChips(
                            isoList: data.timesIso,
                            selectedIndex: data.selectedTimeIndex,
                            onSelect: actions.onSelectTime,
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _SectionTitle('Select Quality', color: colorScheme.onSurface, textTheme: textTheme),
                        const SizedBox(height: 12),
                        QualityChips(
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

class PillChip extends StatelessWidget {
  const PillChip({
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

class DayChips extends StatefulWidget {
  const DayChips({
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
    required this.colorScheme,
    super.key,
  });

  final List<String> days;
  final int selectedIndex;
  final void Function(int) onSelect;
  final ColorScheme colorScheme;

  @override
  State<DayChips> createState() => _DayChipsState();
}

class _DayChipsState extends State<DayChips> {
  final _scrollController = ScrollController();
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.days.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected(animated: false));
  }

  @override
  void didUpdateWidget(covariant DayChips old) {
    super.didUpdateWidget(old);
    if (old.days.length != widget.days.length) {
      _itemKeys = List.generate(widget.days.length, (_) => GlobalKey());
    }
    if (old.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _scrollToSelected({bool animated = true}) {
    if (!_scrollController.hasClients ||
        widget.selectedIndex < 0 ||
        widget.selectedIndex >= _itemKeys.length) return;

    final ctx = _itemKeys[widget.selectedIndex].currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final listBox = context.findRenderObject() as RenderBox?;
    if (listBox == null) return;

    final listWidth = listBox.size.width;
    final itemOffset = box.localToGlobal(Offset.zero, ancestor: listBox).dx;
    final itemWidth = box.size.width;

    final targetOffset =
        _scrollController.offset + (itemOffset + itemWidth / 2 - listWidth / 2);

    final safeOffset = targetOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    if (animated) {
      _scrollController.animateTo(
        safeOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(safeOffset);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 64,
    child: ListView.separated(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.days.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (ctx, i) {
        final d = DateTime.tryParse(widget.days[i]);
        final month = d != null ? _monthShort(d) : '';
        final day = d != null ? '${d.day}' : widget.days[i];
        final sel = i == widget.selectedIndex;

        final topColor = sel ? widget.colorScheme.onPrimaryContainer : widget.colorScheme.onSurface;
        final mainColor = sel ? widget.colorScheme.onPrimaryContainer : widget.colorScheme.onSurface;

        return Container(
          key: _itemKeys[i],
          child: PillChip(
            selected: sel,
            colors: widget.colorScheme,
            height: 56,
            minWidth: 68,
            radius: 14,
            onTap: () => widget.onSelect(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(month, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, height: 1.0, color: topColor)),
                const SizedBox(height: 2),
                Text(day, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.0, color: mainColor)),
              ],
            ),
          ),
        );
      },
    ),
  );

  String _monthShort(DateTime d) =>
      const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1];
}

class TimeChips extends StatefulWidget {
  const TimeChips({
    required this.isoList,
    required this.selectedIndex,
    required this.onSelect,
    required this.colorScheme,
    super.key,
  });

  final List<String> isoList;
  final int selectedIndex;
  final void Function(int) onSelect;
  final ColorScheme colorScheme;

  @override
  State<TimeChips> createState() => _TimeChipsState();
}

class _TimeChipsState extends State<TimeChips> {
  final _scrollController = ScrollController();
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.isoList.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected(animated: false));
  }

  @override
  void didUpdateWidget(covariant TimeChips old) {
    super.didUpdateWidget(old);
    if (old.isoList.length != widget.isoList.length) {
      _itemKeys = List.generate(widget.isoList.length, (_) => GlobalKey());
    }
    if (old.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _scrollToSelected({bool animated = true}) {
    if (!_scrollController.hasClients ||
        widget.selectedIndex < 0 ||
        widget.selectedIndex >= _itemKeys.length) return;

    final ctx = _itemKeys[widget.selectedIndex].currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final listBox = context.findRenderObject() as RenderBox?;
    if (listBox == null) return;

    final listWidth = listBox.size.width;
    final itemOffset = box.localToGlobal(Offset.zero, ancestor: listBox).dx;
    final itemWidth = box.size.width;

    final targetOffset =
        _scrollController.offset + (itemOffset + itemWidth / 2 - listWidth / 2);

    final safeOffset = targetOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    if (animated) {
      _scrollController.animateTo(
        safeOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(safeOffset);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: ListView.separated(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.isoList.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (ctx, i) {
        final dt = DateTime.tryParse(widget.isoList[i])?.toLocal();
        final label = dt == null
            ? widget.isoList[i]
            : '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
        final sel = i == widget.selectedIndex;
        final fg = sel ? widget.colorScheme.onPrimaryContainer : widget.colorScheme.onSurface;

        return Container(
          key: _itemKeys[i],
          child: PillChip(
            selected: sel,
            colors: widget.colorScheme,
            height: 48,
            minWidth: 78,
            radius: 14,
            onTap: () => widget.onSelect(i),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.0, color: fg),
            ),
          ),
        );
      },
    ),
  );
}

class QualityChips extends StatelessWidget {
  const QualityChips({
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
    final is2DSelected = selectedQuality == '2D';
    final is3DSelected = selectedQuality == '3D';

    Color background(bool selected, bool available) {
      if (!available) return colorScheme.surfaceContainerHigh.withOpacity(0.3);
      if (selected) return colorScheme.primary;
      return colorScheme.surfaceContainerHigh;
    }

    Color textColor(bool selected, bool available) {
      if (!available) return colorScheme.onSurface.withOpacity(0.35);
      if (selected) return colorScheme.onPrimaryContainer;
      return colorScheme.onSurface;
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qualityChip(
            label: '2D',
            selected: is2DSelected,
            available: is2DAvailable,
            onTap: is2DAvailable ? onSelect2D : null,
            bg: background(is2DSelected, is2DAvailable),
            fg: textColor(is2DSelected, is2DAvailable),
          ),
          const SizedBox(width: 12),
          _qualityChip(
            label: '3D',
            selected: is3DSelected,
            available: is3DAvailable,
            onTap: is3DAvailable ? onSelect3D : null,
            bg: background(is3DSelected, is3DAvailable),
            fg: textColor(is3DSelected, is3DAvailable),
          ),
        ],
      ),
    );
  }

  Widget _qualityChip({
    required String label,
    required bool selected,
    required bool available,
    required Color bg,
    required Color fg,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? fg.withOpacity(0.9)
                : available
                ? Colors.transparent
                : fg.withOpacity(0.1),
            width: selected ? 1.2 : 1.0,
          ),
        ),
        constraints: const BoxConstraints(minWidth: 72, minHeight: 46),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
