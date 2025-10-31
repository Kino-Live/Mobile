import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/app/app_constants.dart';

import 'package:kinolive_mobile/app/router/router.dart';
import 'package:kinolive_mobile/app/design/theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouter);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: customThemeData,
      routerConfig: router,
    );
  }
}