import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';

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
  final UpdateUserProfile _updateUserProfile;

  ProfileNotifier(
    this._getUserProfile,
    this._updateUserProfile,
  ) : super(const ProfileState());

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

  /// Update user profile (remote + local)
  Future<void> updateProfile(UserUpdateRequest updatedProfile) async {
    state = state.copyWith(isUpdating: true, error: null);
    final result = await _updateUserProfile(
      UpdateUserProfileParams(profile: updatedProfile),
    );
    result.fold(
      (failure) => state = state.copyWith(
        isUpdating: false,
        error: failure.message ?? 'Failed to update profile',
      ),
      (profile) => state = state.copyWith(
        isUpdating: false,
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
