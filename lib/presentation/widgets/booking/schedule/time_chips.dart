import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/schedule/pill_chip.dart';

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

  String _hhmmFromIso(String iso) {
    final m = RegExp(r'T(\d{2}):(\d{2})').firstMatch(iso);
    if (m != null) return '${m.group(1)}:${m.group(2)}';
    final t = iso.split('T');
    if (t.length > 1 && t[1].length >= 5) return t[1].substring(0, 5);
    return iso;
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
        final label = _hhmmFromIso(widget.isoList[i]);
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