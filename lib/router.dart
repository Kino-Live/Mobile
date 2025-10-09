import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/screens/login/login_screen.dart';

import 'package:kinolive_mobile/screens/register/register_screen.dart';
import 'package:kinolive_mobile/screens/register/complete_profile_screen.dart';

import 'package:kinolive_mobile/screens/forgot_password/forgot_password_screen.dart';
import 'package:kinolive_mobile/screens/forgot_password/check_email/check_email_screen.dart';
import 'package:kinolive_mobile/screens/forgot_password/password_reset/password_reset_screen.dart';
import 'package:kinolive_mobile/screens/forgot_password/set_password/set_password_screen.dart';
import 'package:kinolive_mobile/screens/forgot_password/success/success_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
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
          builder: (context, state) => const CheckEmailScreen(),
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
          builder: (context, state) => const SuccessfulScreen(),
        ),
      ],
    ),
  ],
);