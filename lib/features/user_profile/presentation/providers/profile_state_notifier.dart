import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';

/// Profile state that handles loading, success, and error
/// Profile state for handling various states
sealed class ProfileState {}

/// Loading state when the profile is being fetched or updated
class ProfileLoading extends ProfileState {}

/// Success state when the profile is successfully loaded or updated
class ProfileSuccess extends ProfileState {
  final UserProfile profile;

  ProfileSuccess(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  final bool success;

  ProfileUpdateSuccess({required this.message, required this.success});
}

/// Error state when there is a failure in loading or updating the profile
class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

/// Initial state when the profile has not been loaded yet
class ProfileInitial extends ProfileState {}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;

  ProfileNotifier(
    this._getUserProfile,
    this._updateUserProfile,
  ) : super(ProfileInitial());

  /// Load user profile
  Future<void> loadProfile() async {
    state = ProfileLoading(); // Set loading state

    final result = await _getUserProfile();

    result.fold(
      (failure) {
        state = ProfileError(failure.message ?? 'Failed to load profile');
      },
      (profile) {
        state = ProfileSuccess(profile);
      },
    );
  }

  /// Update user profile (remote + local)
  /// Update user profile (remote + local)
  Future<void> updateProfile(UserUpdateRequest updatedProfile) async {
    state = ProfileLoading(); // Set loading state

    final result = await _updateUserProfile(
      UpdateUserProfileParams(profile: updatedProfile),
    );

    print("Update result: $result");

    result.fold(
      (failure) {
        print('Failed to update profile: $failure');
        state = ProfileError(failure.message ?? 'Failed to update profile');
      },
      (profile) {
        print('Profile updated: $profile');
        state = ProfileUpdateSuccess(
          message: profile.message,
          success: profile.success,
        );
      },
    );
  }

  /// Clear error
  void clearError() {
    state = ProfileInitial(); // Reset to initial state
  }

  /// Update profile locally (optimistic update)
  void updateProfileLocally(UserProfile profile) {
    state = ProfileSuccess(profile); // Set success state with updated profile
  }
}
