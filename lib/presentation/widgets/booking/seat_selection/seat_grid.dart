import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';

class SeatGrid extends StatelessWidget {
  const SeatGrid({
    super.key,
    required this.rows,
    required this.selected,
    required this.onToggle,
    this.viewportHeight = 200,
  });

  final List<HallRow> rows;
  final Set<String> selected;
  final void Function(String seatCode) onToggle;
  final double viewportHeight;

  String _rowLabel(int index) => String.fromCharCode('A'.codeUnitAt(0) + index);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: viewportHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
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
                    ),
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
          );
        },
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