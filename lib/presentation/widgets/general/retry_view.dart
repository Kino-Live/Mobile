import 'package:flutter/material.dart';

class RetryView extends StatelessWidget {
  const RetryView({
    super.key,
    required this.onRetry,
    this.message = 'Loading error',
    this.buttonText = 'Retry',
    this.spacing = 12,
  });

  final VoidCallback onRetry;
  final String message;
  final String buttonText;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing),
          FilledButton(
            onPressed: onRetry,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
