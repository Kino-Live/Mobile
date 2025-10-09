import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/router.dart';
import 'package:kinolive_mobile/design/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KinoLive',
      theme: customThemeData,
      routerConfig: appRouter,
    );
  }
}
