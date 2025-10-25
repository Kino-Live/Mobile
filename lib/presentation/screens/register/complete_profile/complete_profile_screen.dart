import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/widgets/auth.dart';
import 'package:kinolive_mobile/presentation/viewmodels/complete_profile_vm.dart';
import 'package:kinolive_mobile/presentation/screens/register/complete_profile/complete_profile_form.dart';

class CompleteProfileScreen extends ConsumerWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(completeProfileVmProvider, (prev, next) {
      if (next.status == CompleteProfileStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!, textAlign: TextAlign.center)),
        );
      }
      if (next.status == CompleteProfileStatus.success) {
        context.go(billboardPath);
      }
    });

    final state = ref.watch(completeProfileVmProvider);
    final isLoading = state.status == CompleteProfileStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: LoadingOverlay(
          loading: isLoading,
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: CompleteProfileForm(),
          ),
        ),
      ),
    );
  }
}
