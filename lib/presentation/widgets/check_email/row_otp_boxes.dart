import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RowOtpBoxes extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final double boxSize;

  const RowOtpBoxes({
    super.key,
    this.length = 5,
    this.onChanged,
    this.onCompleted,
    this.boxSize = 56,
  });

  @override
  State<RowOtpBoxes> createState() => _RowOtpBoxesState();
}

class _RowOtpBoxesState extends State<RowOtpBoxes> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) controller.dispose();
    for (final node in _nodes) node.dispose();
    super.dispose();
  }

  String get _value => _controllers.map((c) => c.text.trim()).join();

  void _focusPrev(int i) {
    if (i > 0) _nodes[i - 1].requestFocus();
  }

  void _focusNext(int i) {
    if (i < _nodes.length - 1) {
      _nodes[i + 1].requestFocus();
    } else {
      _nodes.last.requestFocus();
    }
  }

  void _spreadFrom(int index, String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    var dst = index;
    var src = 0;
    while (dst < _controllers.length && src < digits.length) {
      _controllers[dst].text = digits[src];
      dst++; src++;
    }

    final firstEmpty = _controllers.indexWhere((c) => c.text.isEmpty);
    if (firstEmpty != -1) {
      _nodes[firstEmpty].requestFocus();
    } else {
      _nodes.last.requestFocus();
    }

    final v = _value;
    widget.onChanged?.call(v);
    if (v.length == widget.length && !v.contains(' ')) {
      widget.onCompleted?.call(v);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    OutlineInputBorder boxBorder(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c, width: 1.5),
    );

    InputDecoration deco = InputDecoration(
      counterText: '',
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      enabledBorder: boxBorder(colorScheme.onSurfaceVariant),
      focusedBorder: boxBorder(colorScheme.onSurface),
      errorBorder: boxBorder(colorScheme.error),
      focusedErrorBorder: boxBorder(colorScheme.error),
    );

    Widget box(int i) {
      return SizedBox(
        width: widget.boxSize,
        height: widget.boxSize,
        child: Focus(
          onKeyEvent: (node, event) {
            if (event is! KeyDownEvent) return KeyEventResult.ignored;
            if (event.logicalKey == LogicalKeyboardKey.backspace) {
              if (_controllers[i].text.isEmpty) {
                if (i > 0) {
                  _controllers[i - 1].clear();
                  _nodes[i - 1].requestFocus();
                  widget.onChanged?.call(_value);
                  setState(() {});
                }
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: TextFormField(
            controller: _controllers[i],
            focusNode: _nodes[i],
            textInputAction: i < _controllers.length - 1
                ? TextInputAction.next
                : TextInputAction.done,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: deco,
            onChanged: (raw) {
              final digits = raw.replaceAll(RegExp(r'\D'), '');

              if (digits.isEmpty) {
                _focusPrev(i);
                widget.onChanged?.call(_value);
                setState(() {});
                return;
              }

              if (digits.length == 1) {
                if (_controllers[i].text != digits) {
                  _controllers[i].text = digits;
                }
                _focusNext(i);
                final v = _value;
                widget.onChanged?.call(v);
                if (v.length == widget.length) {
                  widget.onCompleted?.call(v);
                }
                setState(() {});
                return;
              }

              final first = digits[0];
              final rest = digits.substring(1);
              _controllers[i].value = const TextEditingValue(
                text: '',
                selection: TextSelection.collapsed(offset: 0),
              );
              _controllers[i].text = first;
              _spreadFrom(i + 1, rest);
            },
            validator: (v) => (v == null || v.isEmpty) ? '' : null,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, box),
    );
  }
}
