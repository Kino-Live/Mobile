import 'package:flutter/material.dart';
import 'package:kinolive_mobile/screens/login/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});
  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//login
//Enter your email and password to log in

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Login', style: TextTheme.of(context).headlineMedium))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: LoginForm(),
      ),
    );
  }
}