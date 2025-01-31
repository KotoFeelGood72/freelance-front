import 'dart:async';

import 'package:freelance/config/token_storage.dart';
import 'package:freelance/router/app_router.dart';
import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/repositories/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool codeSent;
  final String? phoneNumber;
  final String? role;

  const AuthState({
    this.role,
    this.isLoading = false,
    this.error,
    this.codeSent = false,
    this.phoneNumber,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? codeSent,
    String? phoneNumber,
    String? role,
  }) {
    return AuthState(
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      codeSent: codeSent ?? this.codeSent,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  Timer? _timer;
  int remainingSeconds = 60;
  final AppRouter _router = GetIt.I<AppRouter>();

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _loadRole();
    return const AuthState();
  }

  Future<void> _loadRole() async {
    final savedRole = await TokenStorage.getRole();
    if (savedRole != null) {
      state = state.copyWith(role: savedRole);
    }
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  Future<void> updateRole(String newRole) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authRepository.updateRole(newRole);
      await TokenStorage.saveRole(newRole);
      await TokenStorage.saveToken(response['access_token']!);
      await TokenStorage.saveRefreshToken(response['refresh_token']!);
      // print('tokens $response');
      state = state.copyWith(isLoading: false, role: newRole);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Ошибка смены роли: ${e.toString()}');
    }
  }

  Future<void> requestCode() async {
    final phoneNumber = state.phoneNumber;
    final role = state.role;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      state = state.copyWith(error: 'Номер телефона не указан');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      
      await _authRepository.sendPhoneNumber(phoneNumber, role!);
      state = state.copyWith(isLoading: false, codeSent: true);
      startTimer();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Ошибка');
    }
  }

  Future<void> verifyCode(String code) async {
    if (code.isEmpty) {
      state = state.copyWith(error: 'Код не может быть пустым');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.verifyCode(code);
      state =
          state.copyWith(isLoading: false, error: 'Ошибка', codeSent: false);

      clearPhoneNumber();
      _router.replaceAll([const TaskRoute()]);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resendCode() async {
    final phoneNumber = state.phoneNumber;
    final role = state.role;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      state = state.copyWith(error: 'Номер телефона не указан');
      return;
    }

    state = state.copyWith(isLoading: true, error: 'Ошибка');
    try {
      await _authRepository.sendPhoneNumber(phoneNumber, role!);
      state = state.copyWith(isLoading: false, codeSent: true);
      startTimer();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void startTimer() {
    remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        state = state.copyWith();
      } else {
        timer.cancel();
        state = state.copyWith(error: null);
      }
    });
  }

  void setRole(String role) {
    state = state.copyWith(role: role);
    TokenStorage.saveRole(role);
  }

  Future<void> onSignOut() async {
    try {
      await _authRepository.logout();

      state = const AuthState();
      _router.replaceAll([const WelcomeRoute()]);
    } catch (e, stacktrace) {
      // print('Ошибка при выходе: $e');
      state = state.copyWith(error: 'Ошибка выхода: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
  }

  void clearPhoneNumber() {
    state = state.copyWith(phoneNumber: null);
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());
