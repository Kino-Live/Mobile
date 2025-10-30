import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';

class SeatGrid extends StatefulWidget {
  const SeatGrid({
    super.key,
    required this.rows,
    required this.selected,
    required this.onToggle,
    this.viewportHeight = 200,
    this.maxScale = 3.5,
    this.borderRadius = 24.0,
    this.controller,
    this.resetOnRowsChange = true,
    this.zoomOutFactor = 0.1,
    this.showFitButton = true,
  });

  final List<HallRow> rows;
  final Set<String> selected;
  final void Function(String seatCode) onToggle;
  final double viewportHeight;
  final double maxScale;
  final double borderRadius;
  final TransformationController? controller;
  final bool resetOnRowsChange;

  final double zoomOutFactor;

  final bool showFitButton;

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

  double? _fitScale;
  Matrix4? _fitMatrix;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _rowsHash = _calcRowsHash(widget.rows);
    _tc.addListener(_enforcePanConstraints);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitAndCenterAll());
  }

  @override
  void didUpdateWidget(covariant SeatGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetOnRowsChange) {
      final newHash = _calcRowsHash(widget.rows);
      if (newHash != _rowsHash) {
        _rowsHash = newHash;
        _didSetInitial = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => _fitAndCenterAll());
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
    if (widget.controller == null) _tc.dispose();
    super.dispose();
  }

  void _fitAndCenterAll() {
    if (_didSetInitial) return;

    final viewerBox = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final contentBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewerBox == null || !viewerBox.attached || contentBox == null || !contentBox.attached) return;

    final Size viewport = viewerBox.size;
    final Size content = contentBox.size;
    if (viewport.isEmpty || content.isEmpty) return;

    final double fitW = viewport.width / content.width;
    final double fitH = viewport.height / content.height;
    final double fitScale = math.min(math.min(fitW, fitH), widget.maxScale);

    final double vw = content.width * fitScale;
    final double vh = content.height * fitScale;
    final double ox = (viewport.width - vw) / 2.0;
    final double oy = (viewport.height - vh) / 2.0;

    final Matrix4 m = Matrix4.identity()
      ..scale(fitScale)
      ..translate(ox / fitScale, oy / fitScale);

    _fitScale = fitScale;
    _fitMatrix = m;
    _tc.value = m;
    _didSetInitial = true;

    WidgetsBinding.instance.addPostFrameCallback((_) => _enforcePanConstraints());
  }

  void _enforcePanConstraints() {
    final viewerBox = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final contentBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewerBox == null || !viewerBox.attached || contentBox == null || !contentBox.attached) return;

    final Size viewport = viewerBox.size;
    final Size content = contentBox.size;
    if (viewport.isEmpty || content.isEmpty) return;

    final Matrix4 mat = _tc.value.clone();
    final double scale = mat.getMaxScaleOnAxis();

    final double contentW = content.width * scale;
    final double contentH = content.height * scale;

    double tx = mat.storage[12];
    double ty = mat.storage[13];

    const double eps = 0.5;

    // X
    if (contentW <= viewport.width + eps) {
      final double centeredTx = (viewport.width - contentW) / 2.0;
      if ((tx - centeredTx).abs() > eps) mat.storage[12] = centeredTx;
    } else {
      final double minTx = viewport.width - contentW;
      final double maxTx = 0.0;
      mat.storage[12] = tx.clamp(minTx, maxTx);
    }

    // Y
    if (contentH <= viewport.height + eps) {
      final double centeredTy = (viewport.height - contentH) / 2.0;
      if ((ty - centeredTy).abs() > eps) mat.storage[13] = centeredTy;
    } else {
      final double minTy = viewport.height - contentH;
      final double maxTy = 0.0;
      mat.storage[13] = ty.clamp(minTy, maxTy);
    }

    _tc.value = mat;
  }

  void _resetToFit() {
    if (_fitMatrix != null) {
      _tc.value = _fitMatrix!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _enforcePanConstraints());
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
              if (!_didSetInitial) _fitAndCenterAll();
              else _enforcePanConstraints();
            });

            final double fit = _fitScale ?? 1.0;
            final double dynamicMinScale = math.max(1e-9, fit * widget.zoomOutFactor);

            return Stack(
              children: [
                SizedBox(
                  key: _viewerKey,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: InteractiveViewer(
                    transformationController: _tc,
                    minScale: dynamicMinScale,
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
                if (widget.showFitButton)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Material(
                      color: cs.surface.withOpacity(0.9),
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _resetToFit,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.aspect_ratio, size: 20),
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
    final Color border = isSelected
        ? cs.primary
        : (isReserved ? cs.secondaryContainer : cs.outline);
    final Color fill = isSelected
        ? cs.primary
        : (isReserved ? cs.secondaryContainer : Colors.transparent);

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
