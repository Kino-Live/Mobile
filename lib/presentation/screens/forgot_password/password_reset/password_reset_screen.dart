import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/password_reset/password_reset_form.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
          child: PasswordResetForm(),
        ),
      ),
    );
  }
}
