import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/screens/register/complete_profile/complete_profile_form.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: CompleteProfileForm()
          ),
        )
    );
  }
}
