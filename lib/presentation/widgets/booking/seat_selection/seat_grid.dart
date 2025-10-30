import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';

class SeatGrid extends StatefulWidget {
  const SeatGrid({
    super.key,
    required this.rows,
    required this.selected,
    required this.onToggle,
    this.viewportHeight = 200,
    this.minScale = 0.6,
    this.maxScale = 3.5,
    this.borderRadius = 24.0,
  });

  final List<HallRow> rows;
  final Set<String> selected;
  final void Function(String seatCode) onToggle;
  final double viewportHeight;

  final double minScale;
  final double maxScale;
  final double borderRadius;

  @override
  State<SeatGrid> createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> {
  final TransformationController _tc = TransformationController();
  final GlobalKey _viewerKey = GlobalKey();

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: widget.viewportHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            InteractiveViewer(
              key: _viewerKey,
              transformationController: _tc,
              minScale: widget.minScale,
              maxScale: widget.maxScale,
              panEnabled: true,
              scaleEnabled: true,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(80),
              clipBehavior: Clip.hardEdge,
              child: RepaintBoundary(
                child: _HallContent(
                  rows: widget.rows,
                  selected: widget.selected,
                  onToggle: widget.onToggle,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 24,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        cs.surface.withOpacity(0.9),
                        cs.surface.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HallContent extends StatelessWidget {
  const _HallContent({
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
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int r = 0; r < rows.length; r++) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    _rowLabel(r),
                    textAlign: TextAlign.center,
                    style: tt.labelMedium,
                  ),
                ),
                const SizedBox(width: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < rows[r].seats.length; i++) ...[
                      _SeatTile(
                        code: rows[r].seats[i].code,
                        status: rows[r].seats[i].status,
                        isSelected: selected.contains(rows[r].seats[i].code),
                        onTap: () => onToggle(rows[r].seats[i].code),
                        cs: cs,
                      ),
                      if (i != rows[r].seats.length - 1) const SizedBox(width: 6),
                    ],
                  ],
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 20,
                  child: Text(
                    _rowLabel(r),
                    textAlign: TextAlign.center,
                    style: tt.labelMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
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
    final bool isReserved = status == HallSeatStatus.reserved || status == HallSeatStatus.blocked;
    final Color border = isSelected ? cs.primary : (isReserved ? cs.secondaryContainer : cs.outline);
    final Color fill = isSelected ? cs.primary : (isReserved ? cs.secondaryContainer : Colors.transparent);

    return InkWell(
      onTap: isReserved ? null : onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
