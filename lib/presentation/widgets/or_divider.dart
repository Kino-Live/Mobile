import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('Or', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
        ),
        Expanded(child: Divider(color: colorScheme.outline)),
      ],
    );
  }
}