import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';

final authStateProvider =
NotifierProvider<AuthController, AuthState>(AuthController.new);

enum AuthStatus { unknown, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AuthSession? session;

  const AuthState({
    required this.status,
    this.session,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.authenticated(AuthSession s)
      : this(status: AuthStatus.authenticated, session: s);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  bool get isLoading =>
      status == AuthStatus.loading || status == AuthStatus.unknown;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && session != null;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
  }) =>
      AuthState(
        status: status ?? this.status,
        session: session ?? this.session,
      );
}

class AuthController extends Notifier<AuthState> {
  bool _inited = false;

  @override
  AuthState build() {
    if (!_inited) {
      _inited = true;
      _bootstrap();
    }
    return const AuthState.loading();
  }

  Future<void> _bootstrap() async {
    try {
      final getSavedSession = ref.read(getSavedSessionProvider);
      final saved = await getSavedSession();
      state = saved == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(saved);
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  void markAuthenticated(AuthSession session) {
    state = AuthState.authenticated(session);
  }

  void markUnauthenticated() {
    state = AuthState.unauthenticated();
  }

  Future<void> logout() async {
    final logout = ref.read(logoutUserProvider);
    await logout();
    state = AuthState.unauthenticated();
  }
}
