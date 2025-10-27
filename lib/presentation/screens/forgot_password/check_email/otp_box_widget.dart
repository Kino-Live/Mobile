import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onBackspaceOnEmpty;
  final ValueChanged<String> onChanged;
  final double size;

  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onBackspaceOnEmpty,
    required this.onChanged,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    OutlineInputBorder boxBorder(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c, width: 1.5),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (controller.text.isEmpty) {
              onBackspaceOnEmpty();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: boxBorder(colorScheme.onSurfaceVariant),
            focusedBorder: boxBorder(colorScheme.onSurface),
            errorBorder: boxBorder(colorScheme.error),
            focusedErrorBorder: boxBorder(colorScheme.error),
          ),
          onChanged: onChanged,
          validator: (v) => (v == null || v.isEmpty) ? '' : null,
        ),
      ),
    );
  }
}