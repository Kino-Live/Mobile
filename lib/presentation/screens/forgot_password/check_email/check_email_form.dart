import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';

class CheckEmailForm extends ConsumerStatefulWidget {
  const CheckEmailForm({super.key, required this.email});
  final String email;

  @override
  ConsumerState<CheckEmailForm> createState() => _CheckEmailFormState();
}

class _CheckEmailFormState extends ConsumerState<CheckEmailForm> {
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

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;

    final code = _otpControllers.map((c) => c.text.trim()).join();
    if (code.length != 5) return;

    final ok = await ref.read(forgotPasswordVmProvider.notifier).verifyCode(code);
    final state = ref.read(forgotPasswordVmProvider);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code verified', textAlign: TextAlign.center)),
      );
      context.go('/forgot-password/password-reset');
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!, textAlign: TextAlign.center)),
      );
    }
  }

  String maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 1) return email;

    final name = email.substring(0, atIndex);
    final domain = email.substring(atIndex);

    if (name.length <= 4) {
      return '${name[0]}...$domain';
    } else {
      return '${name.substring(0, 4)}...$domain';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final loading = ref.watch(forgotPasswordVmProvider.select((s) => s.loading));

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
                  text: 'We sent a reset code to ',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                TextSpan(
                  text: maskEmail(widget.email),
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
              onPressed: (!allFilled || loading) ? null : _verify,
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
