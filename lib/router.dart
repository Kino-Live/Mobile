import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/screens/login/login_screen.dart';
import 'package:kinolive_mobile/screens/register/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
  ],
);