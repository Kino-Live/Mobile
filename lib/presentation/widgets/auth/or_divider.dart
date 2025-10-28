import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  final double bottomSpacing;

  const OrDivider({super.key, this.bottomSpacing = 0});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(
        children: [
          Expanded(child: Divider(color: colorScheme.outline)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Or', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
          ),
          Expanded(child: Divider(color: colorScheme.outline)),
        ],
      )
    );
  }
}