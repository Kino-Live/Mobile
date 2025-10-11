import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final AuthSession? session;
  const AuthState({required this.isAuthenticated, required this.isLoading, this.session});

  static const loading = AuthState(isAuthenticated: false, isLoading: true);
  static const unauth  = AuthState(isAuthenticated: false, isLoading: false);
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _init();
    return AuthState.loading;
  }

  Future<void> _init() async {
    final getSavedSession = ref.read(getSavedSessionProvider);
    final session = await getSavedSession();
    state = AuthState(isAuthenticated: session != null, isLoading: false, session: session);
  }

  void markAuthenticated(AuthSession session) {
    state = AuthState(isAuthenticated: true, isLoading: false, session: session);
  }

  Future<void> logout() async {
    final logout = ref.read(logoutUserProvider);
    await logout();
    state = AuthState.unauth;
  }
}

final authStateProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
