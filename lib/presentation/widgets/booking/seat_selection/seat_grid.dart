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
    this.controller,
    this.resetOnRowsChange = true,
  });

  final List<HallRow> rows;
  final Set<String> selected;
  final void Function(String seatCode) onToggle;
  final double viewportHeight;
  final double minScale;
  final double maxScale;
  final double borderRadius;

  final TransformationController? controller;
  final bool resetOnRowsChange;

  @override
  State<SeatGrid> createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> with AutomaticKeepAliveClientMixin {
  late final TransformationController _tc =
      widget.controller ?? TransformationController();

  final GlobalKey _viewerKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();

  bool _didSetInitial = false;
  int _rowsHash = 0;

  double? _fitScaleWidth;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _rowsHash = _calcRowsHash(widget.rows);
    _tc.addListener(_enforcePanConstraints);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitAndCenterTop());
  }

  @override
  void didUpdateWidget(covariant SeatGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.resetOnRowsChange) {
      final newHash = _calcRowsHash(widget.rows);
      if (newHash != _rowsHash) {
        _rowsHash = newHash;
        _didSetInitial = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => _fitAndCenterTop());
      }
    }
  }

  int _calcRowsHash(List<HallRow> rows) {
    int h = 17;
    for (final r in rows) {
      h = 37 * h + r.seats.length;
    }
    return h;
  }

  @override
  void dispose() {
    _tc.removeListener(_enforcePanConstraints);
    if (widget.controller == null) {
      _tc.dispose();
    }
    super.dispose();
  }

  void _fitAndCenterTop() {
    if (_didSetInitial) return;

    final viewerBox = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final contentBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewerBox == null || !viewerBox.attached || contentBox == null || !contentBox.attached) {
      return;
    }

    final Size viewport = viewerBox.size;
    final Size content = contentBox.size;
    if (viewport.isEmpty || content.isEmpty) return;

    double fitScale = viewport.width / content.width;
    fitScale = fitScale.clamp(widget.minScale, widget.maxScale);
    _fitScaleWidth = fitScale;

    final double vw = content.width * fitScale;

    final double ox = (viewport.width - vw) / 2.0;
    final double oy = 0.0;

    final Matrix4 m = Matrix4.identity()
      ..scale(fitScale)
      ..translate(ox / fitScale, oy / fitScale);

    _tc.value = m;
    _didSetInitial = true;

    WidgetsBinding.instance.addPostFrameCallback((_) => _enforcePanConstraints());
  }

  void _enforcePanConstraints() {
    final viewerBox = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final contentBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewerBox == null || !viewerBox.attached || contentBox == null || !contentBox.attached) {
      return;
    }

    final Size viewport = viewerBox.size;
    final Size content = contentBox.size;
    if (viewport.isEmpty || content.isEmpty) return;

    final Matrix4 mat = _tc.value.clone();
    final double scale = mat.getMaxScaleOnAxis();

    final double contentW = content.width * scale;

    double tx = mat.storage[12];
    final double ty = mat.storage[13];

    const double eps = 0.5;

    if (contentW <= viewport.width + eps) {
      final double centeredTx = (viewport.width - contentW) / 2.0;
      if ((tx - centeredTx).abs() > eps) {
        mat.storage[12] = centeredTx;
        _tc.value = mat;
      }
      return;
    }

    final double minTx = viewport.width - contentW;
    final double maxTx = 0.0;

    final double clampedTx = tx.clamp(minTx, maxTx);
    if ((tx - clampedTx).abs() > eps) {
      mat.storage[12] = clampedTx;
      _tc.value = mat;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: widget.viewportHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_didSetInitial) {
                _fitAndCenterTop();
              } else {
                _enforcePanConstraints();
              }
            });

            return Stack(
              children: [
                SizedBox(
                  key: _viewerKey,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: InteractiveViewer(
                    transformationController: _tc,
                    minScale: widget.minScale,
                    maxScale: widget.maxScale,
                    panEnabled: true,
                    scaleEnabled: true,
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(80),
                    clipBehavior: Clip.hardEdge,

                    onInteractionUpdate: (_) => _enforcePanConstraints(),
                    onInteractionEnd: (_) => _enforcePanConstraints(),

                    child: RepaintBoundary(
                      key: _contentKey,
                      child: _HallContent(
                        rows: widget.rows,
                        selected: widget.selected,
                        onToggle: widget.onToggle,
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
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
