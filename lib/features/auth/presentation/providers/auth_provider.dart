import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/user.dart';

// Simple auth state
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
  final LocalStorageService _localStorage;

  AuthNotifier(this._localStorage) : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _localStorage.getAuthToken();
    if (token != null) {
      // User was previously logged in
      final userJson = await _localStorage.getCurrentUser();
      if (userJson != null) {
        state = state.copyWith(
          user: userJson,
          isAuthenticated: true,
        );
      }
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate fast login (replace with actual API call)
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock login - accept any email with valid format
    if (email.contains('@') && password.length >= 6) {
      final mockUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: email.split('@').first,
        email: email,
        dateOfBirth: DateTime(1995, 1, 1),
        gender: 'female',
        createdAt: DateTime.now(),
      );

      await _localStorage.saveAuthToken('mock_token');
      await _localStorage.saveCurrentUser(mockUser);

      state = state.copyWith(
        user: mockUser,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: 'Email au nywila si sahihi',
    );
    return false;
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

    // Simulate fast registration
    await Future.delayed(const Duration(milliseconds: 500));

    final mockUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
      createdAt: DateTime.now(),
    );

    await _localStorage.saveAuthToken('mock_token');
    await _localStorage.saveCurrentUser(mockUser);

    state = state.copyWith(
      user: mockUser,
      isAuthenticated: true,
      isLoading: false,
    );
    return true;
  }

  Future<void> updateCohort(String cohortId) async {
    if (state.user != null) {
      final updatedUser = state.user!.copyWith(cohort: cohortId);
      state = state.copyWith(user: updatedUser);
      await _localStorage.saveCurrentUser(updatedUser);
    }
  }

  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> logout() async {
    await _localStorage.clearAuthData();
    state = const AuthState();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return AuthNotifier(localStorage);
});
