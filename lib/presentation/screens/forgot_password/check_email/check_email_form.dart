import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/presentation/validators/auth_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/forgot_password_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/check_email/row_otp_boxes.dart';
import 'package:kinolive_mobile/presentation/widgets/general/header.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class CheckEmailForm extends ConsumerStatefulWidget {
  const CheckEmailForm({super.key, required this.email});
  final String email;

  @override
  ConsumerState<CheckEmailForm> createState() => _CheckEmailFormState();
}

class _CheckEmailFormState extends ConsumerState<CheckEmailForm> {
  final _formKey = GlobalKey<FormState>();
  String _code = '';

  Future<void> _verify() async {
    if (_code.length != 5) return;

    final ok = await ref.read(forgotPasswordVmProvider.notifier).verifyCode(_code);
    final state = ref.read(forgotPasswordVmProvider);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code verified', textAlign: TextAlign.center)),
      );
      context.go(passwordResetPath);
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!, textAlign: TextAlign.center)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final loading = ref.watch(forgotPasswordVmProvider.select((s) => s.loading));

    final allFilled = _code.length == 5;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(
            title: 'Check your email',
            subtitle: 'Enter the 5-digit code we sent to your email',
            topSpacing: 8,
            bottomSpacing: 0,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'We sent a reset code to ',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextSpan(
                  text: maskEmail(widget.email),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          RowOtpBoxes(
            length: 5,
            onChanged: (v) => setState(() => _code = v),
            onCompleted: (v) {
              setState(() => _code = v);
            },
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: 'Verify Code',
            onPressed: (!allFilled || loading) ? null : _verify,
            loading: loading,
          ),
        ],
      ),
    );
  }
}
