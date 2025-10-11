import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kinolive_mobile/app/router.dart';
import 'package:kinolive_mobile/app/theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouter);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'KinoLive',
      theme: customThemeData,
      routerConfig: router,
    );
  }
}