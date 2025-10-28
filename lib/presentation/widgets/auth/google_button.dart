import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double bottomSpacing;

  const GoogleButton({
    super.key,
    required this.text, required this.onPressed,
    this.bottomSpacing = 0
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: bottomSpacing),
      child: SizedBox(
        height: 56,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: BorderSide(color: colorScheme.onSurface),
            foregroundColor: colorScheme.onSurface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google.png',
                width: 20,
                height: 20,
                errorBuilder: (context, _, __) =>
                const Icon(Icons.g_mobiledata, size: 28),
              ),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}