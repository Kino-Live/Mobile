import 'package:flutter/material.dart';

import 'package:kinolive_mobile/app/router.dart';
import 'package:kinolive_mobile/app/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'KinoLive',
      theme: customThemeData,
      routerConfig: appRouter,
    );
  }
}