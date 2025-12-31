import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tech_challenge_3/core/services/auth_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService() {
    _init();
  }

  AuthStatus get status => _status;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      _status = user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.login(email, password);

    _setLoading(false);

    if (result['success']) {
      return true;
    } else {
      _setError(result['message']);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.register(email, password);

    _setLoading(false);

    if (result['success']) {
      return true;
    } else {
      _setError(result['message']);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
    } catch (e) {
      _setError('Erro ao fazer logout');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
