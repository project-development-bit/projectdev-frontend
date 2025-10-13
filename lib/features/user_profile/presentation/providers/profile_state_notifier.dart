import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';
import 'profile_providers.dart';

/// State for profile operations
class ProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final String? error;
  final bool isUpdating;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.isUpdating = false,
  });

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
    bool? isUpdating,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

/// Profile state notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfile _getUserProfile;

  ProfileNotifier(this._getUserProfile) : super(const ProfileState());

  /// Load user profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getUserProfile();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message ?? 'Failed to load profile',
      ),
      (profile) => state = state.copyWith(
        isLoading: false,
        profile: profile,
        error: null,
      ),
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Update profile locally (optimistic update)
  void updateProfileLocally(UserProfile profile) {
    state = state.copyWith(profile: profile);
  }
}

/// Provider for profile state notifier
final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final getUserProfile = ref.read(getUserProfileUseCaseProvider);
  return ProfileNotifier(getUserProfile);
});