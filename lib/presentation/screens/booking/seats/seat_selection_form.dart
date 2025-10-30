import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/schedule/section_title.dart';

class SeatSelectionFormData {
  final String title;
  final String posterUrl;
  final String cinemaName;
  final String cinemaAddr;
  final String hallName;
  final String dateText;
  final String timeRange;
  final bool is3D;

  final List<HallRow> rows;
  final Set<String> selected;
  final int selectedCount;

  final int movieId;
  final String showtimeId;
  final String date; // YYYY-MM-DD
  final String startIso;
  final String endIso;
  final String quality; // "2D" / "3D"

  const SeatSelectionFormData({
    required this.title,
    required this.posterUrl,
    required this.cinemaName,
    required this.cinemaAddr,
    required this.hallName,
    required this.dateText,
    required this.timeRange,
    required this.is3D,
    required this.rows,
    required this.selected,
    required this.selectedCount,
    required this.movieId,
    required this.showtimeId,
    required this.date,
    required this.startIso,
    required this.endIso,
    required this.quality,
  });
}

class SeatSelectionFormActions {
  final VoidCallback onBack;
  final Future<void> Function() onRefresh;
  final void Function(String seatCode) onToggleSeat;
  final VoidCallback onClear;
  final VoidCallback onContinue;

  const SeatSelectionFormActions({
    required this.onBack,
    required this.onRefresh,
    required this.onToggleSeat,
    required this.onClear,
    required this.onContinue,
  });
}

class SeatSelectionForm extends StatelessWidget {
  const SeatSelectionForm({
    super.key,
    required this.data,
    required this.actions,
  });

  final SeatSelectionFormData data;
  final SeatSelectionFormActions actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      color: cs.surface,
      child: InstantRefreshScrollView(
        onRefresh: actions.onRefresh,
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: cs.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: actions.onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            centerTitle: true,
            title: Text(
              'Select Seat',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: data.posterUrl.isEmpty
                                  ? Container(color: Colors.black26)
                                  : Image.network(
                                data.posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(color: Colors.black26),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _InfoRow(
                                icon: Icons.place_outlined,
                                text:
                                '${data.cinemaName}${data.hallName.isNotEmpty ? ', ${data.hallName}' : ''}\n${data.cinemaAddr}',
                              ),
                              const SizedBox(height: 6),
                              _InfoRow(
                                icon: Icons.calendar_today_outlined,
                                text: data.dateText,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: _InfoRow(
                                      icon: Icons.schedule,
                                      text: data.timeRange,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _Tag(text: data.is3D ? '3D' : '2D'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SectionTitle('Select seats',
                            color: cs.onSurface, textTheme: tt),
                        const SizedBox(height: 12),

                        _ScreenLine(color: cs.primary.withOpacity(0.35)),
                        const SizedBox(height: 10),

                        _SeatGrid(
                          rows: data.rows,
                          selected: data.selected,
                          onToggle: actions.onToggleSeat,
                        ),

                        const SizedBox(height: 10),
                        _Legend(cs: cs),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  if (data.selectedCount > 0)
                    TextButton(
                      onPressed: actions.onClear,
                      child: Text('Clear selection (${data.selectedCount})'),
                    ),
                  const SizedBox(height: 8),

                  PrimaryButton(
                    text: 'Continue',
                    onPressed: actions.onContinue,
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimaryContainer,
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

// ===== helpers =====

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: cs.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style:
            tt.bodySmall?.copyWith(color: cs.onSurfaceVariant, height: 1.2),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _ScreenLine extends StatelessWidget {
  const _ScreenLine({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: CustomPaint(
        painter: _ArcPainter(color),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(6, 0, size.width - 12, size.height * 1.6);
    const pi = 3.1415926535;
    final start = 200 * pi / 180;
    final sweep = 140 * pi / 180;
    canvas.drawArc(rect, start, sweep, false, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Legend extends StatelessWidget {
  const _Legend({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        _LegendItem(color: cs.primary, filled: true, label: 'Selected'),
        const SizedBox(width: 12),
        _LegendItem(color: cs.secondaryContainer, filled: true, label: 'Reserved'),
        const SizedBox(width: 12),
        _LegendItem(color: cs.outline, filled: false, label: 'Available'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.filled, required this.label});
  final Color color;
  final bool filled;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: tt.labelMedium),
      ],
    );
  }
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({
    required this.rows,
    required this.selected,
    required this.onToggle,
  });

  final List<HallRow> rows;
  final Set<String> selected;
  final void Function(String seatCode) onToggle;

  String _rowLabel(int index) => String.fromCharCode('A'.codeUnitAt(0) + index);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Column(
              children: [
                for (int r = 0; r < rows.length; r++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        child: Text(
                          _rowLabel(r),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(width: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < rows[r].seats.length; i++) ...[
                            _SeatTile(
                              code: rows[r].seats[i].code,
                              status: rows[r].seats[i].status,
                              isSelected: selected.contains(rows[r].seats[i].code),
                              onTap: () => onToggle(rows[r].seats[i].code),
                              cs: cs,
                            ),
                            if (i != rows[r].seats.length - 1)
                              const SizedBox(width: 6),
                          ],
                        ],
                      ),

                      const SizedBox(width: 6),

                      SizedBox(
                        width: 20,
                        child: Text(
                          _rowLabel(r),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SeatTile extends StatelessWidget {
  const _SeatTile({
    required this.code,
    required this.status,
    required this.isSelected,
    required this.onTap,
    required this.cs,
  });

  final String code;
  final HallSeatStatus status;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final bool isReserved =
        status == HallSeatStatus.reserved || status == HallSeatStatus.blocked;
    final Color border =
    isSelected ? cs.primary : (isReserved ? cs.secondaryContainer : cs.outline);
    final Color fill =
    isSelected ? cs.primary : (isReserved ? cs.secondaryContainer : Colors.transparent);

    return InkWell(
      onTap: isReserved ? null : onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
