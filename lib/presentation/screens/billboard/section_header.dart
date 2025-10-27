import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.onAction,
    this.actionText = 'See more',
  });

  final String title;
  final VoidCallback onAction;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(title, style: tt.titleLarge?.copyWith(color: cs.onSurface)),
        const Spacer(),
        OutlinedButton(
          onPressed: onAction,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: const StadiumBorder(),
            side: BorderSide(color: cs.onSurfaceVariant),
            foregroundColor: cs.onSurfaceVariant,
            textStyle: tt.labelLarge,
          ),
          child: Text(actionText),
        ),
      ],
    );
  }
}
