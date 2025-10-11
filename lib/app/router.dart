import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:kinolive_mobile/presentation/screens/splash/splash_screen.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';

class GoRouterRefresh extends ChangeNotifier {
  GoRouterRefresh(this.ref) {
    _sub = ref.listen<AuthState>(
      authStateProvider,
          (_, __) => notifyListeners(),
      fireImmediately: false,
    );
  }
  final Ref ref;
  late final ProviderSubscription<AuthState> _sub;
  @override void dispose() { _sub.close(); super.dispose(); }
}


final appRouter = Provider<GoRouter>((ref) {
  final refresh = GoRouterRefresh(ref);

  bool isPublic(String l) =>
      l.startsWith('/login') ||
      l.startsWith('/register') ||
      l.startsWith('/forgot-password') ||
      l == '/splash';

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/',       builder: (context, state) => const BillboardScreen()),
      GoRoute(path: '/login',  builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
        routes: [
          GoRoute(
            path: 'complete-profile',
            builder: (context, state) => const CompleteProfileScreen(),
          ),
        ],
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
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final location  = state.matchedLocation;

      if (auth.isLoading) return (location == '/splash') ? null : '/splash';

      if (!auth.isAuthenticated) {
        return isPublic(location) ? null : '/login';
      }

      if (isPublic(location)) return '/';

      return null;
    },
  );
});
