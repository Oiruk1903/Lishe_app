import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final LocalStorageService _localStorage;

  AuthNotifier(this._repository, this._localStorage) : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _localStorage.getAuthToken();
    if (token != null) {
      final user = await _localStorage.getCurrentUser();
      if (user != null) {
        state = state.copyWith(user: user, isAuthenticated: true);
      }
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(email: email, password: password);
      state = state.copyWith(user: user, isAuthenticated: true, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required String gender,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        gender: gender,
        password: password,
      );
      state = state.copyWith(user: user, isAuthenticated: true, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  Future<void> updateCohort(String cohortId) async {
    if (state.user != null) {
      await _repository.updateUserCohort(cohortId);
      final updatedUser = state.user!.copyWith(cohort: cohortId);
      state = state.copyWith(user: updatedUser);
      await _localStorage.saveCurrentUser(updatedUser);
    }
  }

  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid credentials') || msg.contains('401')) {
      return 'Barua pepe au nywila si sahihi';
    }
    if (msg.contains('already exists') || msg.contains('409')) {
      return 'Barua pepe hii tayari imesajiliwa';
    }
    if (msg.contains('network') || msg.contains('connection')) {
      return 'Hakuna muunganiko wa mtandao';
    }
    return 'Hitilafu imetokea. Jaribu tena';
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(dio),
    localDataSource: AuthLocalDataSourceImpl(prefs),
  );
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final localStorage = ref.watch(localStorageServiceProvider);
  return AuthNotifier(repository, localStorage);
});
