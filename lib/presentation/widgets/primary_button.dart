import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final double bottomSpacing;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final OutlinedBorder? shape;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.bottomSpacing = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bg = backgroundColor ?? colorScheme.primaryContainer;
    final fg = foregroundColor ?? colorScheme.onPrimaryContainer;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: SizedBox(
        height: 56,
        child: FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            shape: shape ?? const StadiumBorder(),
          ),
          child: Text(text),
        ),
      )
    );
  }
}
