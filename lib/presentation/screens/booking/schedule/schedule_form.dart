import 'package:flutter/material.dart';

class ScheduleForm extends StatelessWidget {
  const ScheduleForm({
    super.key,
    required this.title,
    required this.posterUrl,
    required this.availableDays,
    required this.selectedDayIndex,
    required this.quality, // "2D" | "3D"
    required this.times,   // ISO strings
    required this.selectedTimeIndex,
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
    this.onRefresh,
  });

  final String title;
  final String posterUrl;

  final List<String> availableDays;
  final int selectedDayIndex;

  final String quality; // "2D" | "3D"

  final List<String> times; // ISO start times
  final int selectedTimeIndex;

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
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 240,
            elevation: 0,
            leading: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Poster
                  Image.network(
                    posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.black26),
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
                ],
              ),
            ),
          ),

          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Center(
                child: Text(
                  title,
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Card with selectors
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1D22),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Select Day
                    const _SectionTitle('Select Day'),
                    const SizedBox(height: 12),
                    _ArrowStrip(
                      onPrev: onPrevDay,
                      onNext: onNextDay,
                      child: _DayChips(
                        days: availableDays,
                        selectedIndex: selectedDayIndex,
                        onSelect: onSelectDay,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Select Time
                    const _SectionTitle('Select Time'),
                    const SizedBox(height: 12),
                    _ArrowStrip(
                      onPrev: onPrevTime,
                      onNext: onNextTime,
                      child: _TimeChips(
                        isoList: times,
                        selectedIndex: selectedTimeIndex,
                        onSelect: onSelectTime,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Select Quality
                    const _SectionTitle('Select Quality'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('2D'),
                            selected: quality == '2D',
                            onSelected: (_) => onSet2D(),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('3D'),
                            selected: quality == '3D',
                            onSelected: (_) => onSet3D(),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: onContinue,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==== Private widgets ====

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));
  }
}

class _ArrowStrip extends StatelessWidget {
  const _ArrowStrip({required this.child, required this.onPrev, required this.onNext});
  final Widget child;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _circleIcon(context, Icons.chevron_left, onPrev),
        const SizedBox(width: 8),
        Expanded(child: child),
        const SizedBox(width: 8),
        _circleIcon(context, Icons.chevron_right, onNext),
      ],
    );
  }

  Widget _circleIcon(BuildContext ctx, IconData icon, VoidCallback onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2A2D34)),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _DayChips extends StatelessWidget {
  const _DayChips({
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> days; // "YYYY-MM-DD"
  final int selectedIndex;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final d = DateTime.tryParse(days[i]);
          final labelTop = d != null ? _monthShort(d) : '';
          final labelBottom = d != null ? '${d.day}' : days[i];
          final selected = i == selectedIndex;

          return ChoiceChip(
            selected: selected,
            onSelected: (_) => onSelect(i),
            label: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(labelTop, style: const TextStyle(fontSize: 12)),
                Text(labelBottom),
              ],
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  String _monthShort(DateTime d) {
    // TODO: Localize month names
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[d.month - 1];
  }
}

class _TimeChips extends StatelessWidget {
  const _TimeChips({
    required this.isoList,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> isoList; // start_iso
  final int selectedIndex;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: isoList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final selected = i == selectedIndex;
          final label = _formatTime(isoList[i], ctx);
          return ChoiceChip(
            selected: selected,
            onSelected: (_) => onSelect(i),
            label: Text(label),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  String _formatTime(String iso, BuildContext ctx) {
    // TODO: Use intl if you want locale-aware formatting
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return iso;
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $ampm';
  }
}
