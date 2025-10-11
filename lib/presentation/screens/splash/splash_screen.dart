import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateProvider);

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
