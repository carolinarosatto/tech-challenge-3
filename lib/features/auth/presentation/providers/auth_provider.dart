import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tech_challenge_3/core/errors/error_handler.dart';
import 'package:tech_challenge_3/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/register_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/watch_auth_state_usecase.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required WatchAuthStateUseCase watchAuthStateUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _watchAuthStateUseCase = watchAuthStateUseCase {
    _init();
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final WatchAuthStateUseCase _watchAuthStateUseCase;

  StreamSubscription<AuthUserEntity?>? _authStateSubscription;

  AuthStatus _status = AuthStatus.initial;
  AuthUserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthStatus get status => _status;
  AuthUserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  void _init() {
    _authStateSubscription = _watchAuthStateUseCase.execute().listen((user) {
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

    final result = await _loginUseCase.execute(
      email: email,
      password: password,
    );

    _setLoading(false);

    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        _setError(ErrorHandler.toMessage(failure));
        return false;
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _registerUseCase.execute(
      email: email,
      password: password,
    );

    _setLoading(false);

    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        _setError(ErrorHandler.toMessage(failure));
        return false;
      },
    );
  }

  Future<void> logout() async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    final result = await _logoutUseCase.execute();

    result.fold(
      onSuccess: (_) {
        _user = null;
        _status = AuthStatus.unauthenticated;
      },
      onFailure: (failure) {
        _setError(ErrorHandler.toMessage(failure));
      },
    );

    _isLoading = false;
    notifyListeners();
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

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
