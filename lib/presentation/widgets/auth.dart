import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingOverlay extends StatelessWidget {
  final bool loading;
  final Widget child;
  const LoadingOverlay({super.key, required this.loading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        AnimatedOpacity(
          opacity: loading ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: IgnorePointer(
            ignoring: !loading,
            child: Container(
              color: Colors.black.withAlpha(51),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double topSpacing;
  final double bottomSpacing;
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.topSpacing,
    required this.bottomSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(height: topSpacing),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: bottomSpacing)
      ],
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double bottomSpacing;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.validator,
    required this.bottomSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          validator: validator,
        ),
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}

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

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
        child: Text(text),
      ),
    );
  }
}

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

class GoogleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const GoogleButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
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
    );
  }
}

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
