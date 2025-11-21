import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UpdateProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class UpdateProfileState {
  final UpdateProfileStatus status;
  final String? errorMessage;

  bool get isLoading => status == UpdateProfileStatus.loading;

  UpdateProfileState({
    this.status = UpdateProfileStatus.initial,
    this.errorMessage,
  });

  UpdateProfileState copyWith({
    UpdateProfileStatus? status,
    String? errorMessage,
  }) {
    return UpdateProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final updateProfileProvider = StateNotifierProvider<
    UpdateProfileProvider, UpdateProfileState>(
  (ref) {
    final updateUserProfileUsecase =
        ref.watch(updateUserProfileUseCaseProvider);
    return UpdateProfileProvider(
      UpdateProfileState(),
      updateUserProfileUsecase,
    );
  },
);

class UpdateProfileProvider extends StateNotifier<UpdateProfileState>{
  final UpdateUserProfile _updateUserProfile;
  UpdateProfileProvider(super.state,this._updateUserProfile);


  Future<void> updateProfile(UserUpdateRequest updatedProfile) async {
    state = state.copyWith(status: UpdateProfileStatus.loading, errorMessage: null);

    final result = await _updateUserProfile(
      UpdateUserProfileParams(profile: updatedProfile),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UpdateProfileStatus.failure,
          errorMessage: failure.message ?? 'Failed to update profile',
        );
      },
      (profile) {
        state = state.copyWith(status: UpdateProfileStatus.success);
      },
    );
  }
  
}
