import 'package:flutter/material.dart';

class InstantRefreshScrollView extends StatefulWidget {
  const InstantRefreshScrollView({
    super.key,
    required this.slivers,
    this.onRefresh,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.refreshBlockAreas,
  });

  final List<Widget> slivers;
  final Future<void> Function()? onRefresh;
  final ScrollPhysics physics;
  final List<GlobalKey>? refreshBlockAreas;

  @override
  State<InstantRefreshScrollView> createState() => _InstantRefreshScrollViewState();
}

class _InstantRefreshScrollViewState extends State<InstantRefreshScrollView> {
  bool _allowRefresh = true;
  bool _allowScroll = true;

  Future<void> _instant() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }
  }

  bool _isPointInsideBlockedArea(Offset globalPos) {
    if (widget.refreshBlockAreas == null) return false;
    for (final key in widget.refreshBlockAreas!) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject();
      if (box is! RenderBox || !box.attached) continue;
      final topLeft = box.localToGlobal(Offset.zero);
      final size = box.size;
      final rect = Rect.fromLTWH(topLeft.dx, topLeft.dy, size.width, size.height);
      if (rect.contains(globalPos)) return true;
    }
    return false;
  }

  bool _notificationPredicate(ScrollNotification notification) {
    if (!_allowRefresh) return false;
    return notification.depth == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        final inside = _isPointInsideBlockedArea(event.position);

        if (inside != !_allowRefresh || inside != !_allowScroll) {
          setState(() {
            _allowRefresh = !inside;
            _allowScroll  = !inside;
          });
        } else {
          _allowRefresh = !inside;
          _allowScroll  = !inside;
        }
      },
      onPointerUp: (_) {
        if (!_allowRefresh || !_allowScroll) {
          setState(() {
            _allowRefresh = true;
            _allowScroll  = true;
          });
        }
      },
      child: RefreshIndicator(
        notificationPredicate: _notificationPredicate,
        onRefresh: _instant,
        child: CustomScrollView(
          physics: _allowScroll ? widget.physics : const NeverScrollableScrollPhysics(),
          slivers: widget.slivers,
        ),
      ),
    );
  }
}
