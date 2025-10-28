import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordField extends HookWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final double bottomSpacing;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
    required this.bottomSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final obscure = useState<bool>(true);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface)),
        TextFormField(
          controller: controller,
          obscureText: obscure.value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            suffixIcon: IconButton(
              onPressed: () => obscure.value = !obscure.value,
              icon: Icon(
                obscure.value ? Icons.visibility_off : Icons.visibility,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          validator: validator,
        ),
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}