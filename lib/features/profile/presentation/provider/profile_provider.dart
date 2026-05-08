import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/timeout_utils.dart';
import '../../../../core/utils/cache_utils.dart';
import '../../domain/entities/user_profile.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Profile provider with caching
final profileProvider = FutureProvider<UserProfile?>((ref) async {
  // Only load when user is authenticated, not during initialization
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return null;

  final user = authState.user!;
  final cacheKey = 'profile_${user.id}';

  return await ProviderCache.getOrFetch<UserProfile?>(
    cacheKey,
    () async {
      return await TimeoutUtils.withTimeoutAndFallback<UserProfile?>(
        Future.value(UserProfile(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          dateOfBirth: user.dateOfBirth,
          gender: user.gender,
          cohort: user.cohort,
          profileImage: null,
          height: user.height,
          targetWeight: user.targetWeight,
          preferredLanguage: 'sw',
          notificationSettings: {},
          createdAt: user.createdAt,
        )),
        timeout: TimeoutUtils.databaseTimeout,
        fallback: null,
        operation: 'Load Profile',
      );
    },
    ttl: ProviderCache.longTtl,
  );
});

// Profile Form State
class ProfileFormState {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final double? height;
  final double? targetWeight;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ProfileFormState({
    this.fullName = '',
    this.email = '',
    this.phoneNumber,
    this.height,
    this.targetWeight,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ProfileFormState copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    double? height,
    double? targetWeight,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ProfileFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  final Ref _ref;

  ProfileFormNotifier(this._ref) : super(const ProfileFormState());

  void initialize(UserProfile profile) {
    state = ProfileFormState(
      fullName: profile.fullName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      height: profile.height,
      targetWeight: profile.targetWeight,
    );
  }

  void updateFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePhoneNumber(String? value) {
    state = state.copyWith(phoneNumber: value);
  }

  void updateHeight(String? value) {
    state = state.copyWith(height: double.tryParse(value ?? ''));
  }

  void updateTargetWeight(String? value) {
    state = state.copyWith(targetWeight: double.tryParse(value ?? ''));
  }

  Future<bool> submit() async {
    final authState = _ref.read(authNotifierProvider);
    final currentUser = authState.user;
    if (currentUser == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate profile update (no database in simplified setup)
      await Future.delayed(const Duration(milliseconds: 500));

      // Update auth state directly
      final updatedUser = currentUser.copyWith(
        fullName: state.fullName,
        email: state.email,
        phoneNumber: state.phoneNumber,
        height: state.height,
        targetWeight: state.targetWeight,
      );

      _ref.read(authNotifierProvider.notifier).updateUser(updatedUser);

      // Invalidate cache and provider to refresh data
      CacheUtils.invalidate('profile_${currentUser.id}');
      _ref.invalidate(profileProvider);

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const ProfileFormState();
  }
}

final profileFormNotifierProvider =
    StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) {
  return ProfileFormNotifier(ref);
});
