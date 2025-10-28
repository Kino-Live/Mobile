import 'package:flutter/material.dart';

class FooterTextLink extends StatelessWidget {
  final String leading;
  final String action;
  final VoidCallback onTap;
  final Color? actionColor;
  const FooterTextLink({
    super.key,
    required this.leading,
    required this.action,
    required this.onTap,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leading, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(action, style: TextStyle(color: actionColor)),
        ),
      ],
    );
  }
}
