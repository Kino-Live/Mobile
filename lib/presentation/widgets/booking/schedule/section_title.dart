import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {required this.textTheme, required this.color, super.key});
  final String text;
  final Color color;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: textTheme.titleMedium,
  );
}