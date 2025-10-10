import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/check_email/check_email_form.dart';

class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key, required this.email});
  final String email;

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        leading: IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: CheckEmailForm(email: widget.email),
        ),
      ),
    );
  }
}


