import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CheckEmailForm extends StatefulWidget {
  const CheckEmailForm({super.key});

  @override
  State<CheckEmailForm> createState() => _CheckEmailFormState();
}

class _CheckEmailFormState extends State<CheckEmailForm> {
  final _formKey = GlobalKey<FormState>();

  // 5 controllers and focuses for code entry
  final _otpControllers = List.generate(5, (_) => TextEditingController());
  final _otpNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (final controll in _otpControllers) controll.dispose();
    for (final node in _otpNodes) node.dispose();
    super.dispose();
  }

  void _verify() {
    if (_formKey.currentState!.validate()) {
      // TODO: verify code here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code verified')),
      );
      context.go('/forgot-password/password-reset');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    OutlineInputBorder _boxBorder(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c, width: 1.5),
    );

    InputDecoration _otpDecoration(BuildContext context) => InputDecoration(
      counterText: '',
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      enabledBorder: _boxBorder(colorScheme.onSurfaceVariant),
      focusedBorder: _boxBorder(colorScheme.onSurface),
      errorBorder: _boxBorder(Theme.of(context).colorScheme.error),
      focusedErrorBorder: _boxBorder(Theme.of(context).colorScheme.error),
    );

    // otp (One-Time Password)
    Widget _otpBox(int i) {
      return SizedBox(
        width: 56,
        height: 56,
        child: TextFormField(
          controller: _otpControllers[i],
          focusNode: _otpNodes[i],
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: _otpDecoration(context),
          onChanged: (v) {
            if (v.isNotEmpty) {
              if (i < _otpNodes.length - 1) {
                _otpNodes[i + 1].requestFocus();
              } else {
                _otpNodes[i].unfocus();
              }
            } else {
              if (i > 0) _otpNodes[i - 1].requestFocus();
            }
            setState(() {});
          },
          validator: (v) => (v == null || v.isEmpty) ? '' : null,
        ),
      );
    }

    final allFilled = _otpControllers.every((c) => c.text.trim().isNotEmpty);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          Text(
            'Check your email',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'We sent a reset link to ',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextSpan(
                  text: 'contact@dscode...com',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '\nenter 5 digit code that mentioned in the email',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) => _otpBox(i)),
          ),

          const SizedBox(height: 40),

          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: allFilled ? _verify : null,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
              child: const Text('Verify Code'),
            ),
          ),
        ],
      ),
    );
  }
}
