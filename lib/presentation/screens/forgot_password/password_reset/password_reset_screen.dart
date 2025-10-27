import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/password_reset/password_reset_form.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: const SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 72, 24, 24),
            child: PasswordResetForm(),
          ),
        ),
      ),
    );
  }
}
