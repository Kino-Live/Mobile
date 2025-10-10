import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/presentation/screens/login/login_screen.dart';

import 'package:kinolive_mobile/presentation/screens/register/register_screen.dart';
import 'package:kinolive_mobile/presentation/screens/register/complete_profile/complete_profile_screen.dart';

import 'package:kinolive_mobile/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/check_email/check_email_screen.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/password_reset/password_reset_screen.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/set_password/set_password_screen.dart';
import 'package:kinolive_mobile/presentation/screens/forgot_password/success/success_screen.dart';

import 'package:kinolive_mobile/presentation/screens/billboard/billboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const BillboardScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
      routes: [
        GoRoute(
          path: 'complete-profile',
          builder: (context, state) => const CompleteProfileScreen(),
        )
      ]
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
      routes: [
        GoRoute(
          path: 'check-email',
            builder: (context, state) {
              final email = state.extra as String;
              return CheckEmailScreen(email: email);
            },
        ),
        GoRoute(
          path: 'password-reset',
          builder: (context, state) => const PasswordResetScreen(),
        ),
        GoRoute(
          path: 'set-password',
          builder: (context, state) => const SetPasswordScreen(),
        ),
        GoRoute(
          path: 'successful',
          builder: (context, state) => const SuccessScreen(),
        ),
      ],
    ),
  ],
);