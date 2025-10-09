import 'package:flutter/material.dart';
import 'package:kinolive_mobile/design/theme.dart';

import 'package:kinolive_mobile/screens/login/login_screen.dart';
import 'package:kinolive_mobile/screens/register/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinoLive',
      theme: customThemeData,
      home: const LoginScreen(title: 'KinoLive'),
    );
  }
}