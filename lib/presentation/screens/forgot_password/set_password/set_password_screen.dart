import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/set_password/set_password_form.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
          child: SetPasswordForm(),
        ),
      ),
    );
  }
}