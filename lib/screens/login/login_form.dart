import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          children: [
            Text('Email'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Password'),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your password',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        )
    );
  }
}