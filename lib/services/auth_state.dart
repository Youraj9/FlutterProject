import 'package:flutter/foundation.dart';

import '../models/auth_user.dart';
import 'auth_service.dart';
import 'token_storage.dart';

class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier({AuthService? authService})
    : _authService = authService ?? AuthService();

  static final AuthStateNotifier instance = AuthStateNotifier();

  final AuthService _authService;
  bool _restoreStarted = false;
  int _sessionVersion = 0;

  bool isLoading = true;
  AuthUser? user;
  Object? restoreError;

  bool get isLoggedIn => user != null;

  Future<void> restoreSession() async {
    if (isLoading && _restoreStarted) return;

    _restoreStarted = true;
    isLoading = true;
    restoreError = null;
    final sessionVersion = _sessionVersion;
    notifyListeners();

    try {
      final token = await TokenStorage.getToken();
      final restoredUser = token == null || token.isEmpty
          ? null
          : await _authService.getCurrentUser();
      if (sessionVersion == _sessionVersion) user = restoredUser;
    } catch (error) {
      if (sessionVersion == _sessionVersion) {
        user = null;
        restoreError = error;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setAuthenticated(AuthUser authenticatedUser) {
    _sessionVersion++;
    user = authenticatedUser;
    restoreError = null;
    isLoading = false;
    _restoreStarted = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    setUnauthenticated();
  }

  void setUnauthenticated() {
    _sessionVersion++;
    user = null;
    restoreError = null;
    isLoading = false;
    notifyListeners();
  }
}
