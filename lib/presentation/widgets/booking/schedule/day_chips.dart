import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/schedule/pill_chip.dart';

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