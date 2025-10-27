import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kinolive_mobile/app/router_path.dart';
import 'package:kinolive_mobile/presentation/validators/profile_validators.dart';
import 'package:kinolive_mobile/presentation/viewmodels/complete_profile_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/header.dart';
import 'package:kinolive_mobile/presentation/widgets/labeled_text_field.dart';
import 'package:kinolive_mobile/presentation/widgets/primary_button.dart';

class CompleteProfileForm extends HookConsumerWidget {
  const CompleteProfileForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useTextEditingController();
    final phone = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final state = ref.watch(completeProfileVmProvider);

    Future<void> onContinue() async {
      if (!formKey.currentState!.validate()) return;
      await ref.read(completeProfileVmProvider.notifier).saveProfile(
        name: name.text.trim(),
        phone: phone.text.trim(),
      );
    }

    void onSkip() => context.go(billboardPath);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(
            title: 'Complete your profile',
            subtitle: 'Enter your name and phone number',
            topSpacing: 24,
            bottomSpacing: 40,
          ),

          LabeledTextField(
            label: 'Name',
            controller: name,
            hint: 'Enter your name',
            validator: ProfileValidators.name,
            bottomSpacing: 24,
          ),

          LabeledTextField(
            label: 'Phone number',
            controller: phone,
            hint: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            validator: ProfileValidators.phone,
            bottomSpacing: 40,
          ),

          PrimaryButton(
            text: 'Continue',
            onPressed: state.status == CompleteProfileStatus.loading ? null : onContinue,
            loading: state.status == CompleteProfileStatus.loading,
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: onSkip,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Skip'),
            ),
          ),
        ],
      ),
    );
  }
}
