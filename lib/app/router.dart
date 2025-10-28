import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kinolive_mobile/app/router_path.dart';

import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/movie_details/movie_details_screen.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/see_more/now_showing_screen.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/see_more/popular_screen.dart';

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

const List<String> publicPaths = <String>[
  splashPath,
  loginPath,
  registerPath,
  completeProfilePath,
  forgotPasswordPath,
  checkEmailPath,
  passwordResetPath,
  setPasswordPath,
  successfulPath,
];

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

  return GoRouter(
    initialLocation: splashPath,
    refreshListenable: refresh,
    routes: [
      GoRoute(path: splashPath, builder: (context, state) => const SplashScreen()),
      GoRoute(path: loginPath,  builder: (context, state) => const LoginScreen()),
      GoRoute(path: billboardPath, builder: (context, state) => const BillboardScreen()),
      GoRoute(path: seeMoreNowShowingPath, builder: (context, state) => const NowShowingScreen()),
      GoRoute(path: seeMorePopularPath, builder: (context, state) => const PopularScreen()),
      GoRoute(
        path: movieByIdPath,
        name: movieDetailsName,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MovieDetailsScreen(id: id);
        },
      ),
      GoRoute(path: registerPath, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: completeProfilePath, builder: (context, state) => const CompleteProfileScreen()),
      GoRoute(path: forgotPasswordPath, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
        path: checkEmailPath,
        builder: (context, state) {
          final email = state.extra as String;
          return CheckEmailScreen(email: email);
        },
      ),
      GoRoute(path: passwordResetPath, builder: (context, state) => const PasswordResetScreen()),
      GoRoute(path: setPasswordPath, builder: (context, state) => const SetPasswordScreen()),
      GoRoute(path: successfulPath, builder: (context, state) => const SuccessScreen()),
    ],
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final loc = state.matchedLocation;
      debugPrint('[Router] redirect from=$loc, status=${auth.status}');

      if (auth.isLoading) {
        return (loc == splashPath) ? null : splashPath;
      }

      if (!auth.isAuthenticated) {
        if (loc == splashPath) return loginPath;

        final isPublic = publicPaths.any((p) => loc.startsWith(p));
        return isPublic ? null : loginPath;
      }

      if (loc == splashPath || loc.startsWith(loginPath)) return billboardPath;

      return null;
    },
  );
});
