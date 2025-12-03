import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChangeCountryStatus {
  initial,
  changing,
  success,
  failure,
}

class ChangeCountryState {
  final ChangeCountryStatus status;
  final String? errorMessage;

  bool get isChanging => status == ChangeCountryStatus.changing;
  bool get hasError => status == ChangeCountryStatus.failure;

  ChangeCountryState({
    this.status = ChangeCountryStatus.initial,
    this.errorMessage,
  });

  ChangeCountryState copyWith({
    ChangeCountryStatus? status,
    String? errorMessage,
  }) {
    return ChangeCountryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final changeCountryProvider =
    StateNotifierProvider<ChangeCountryNotifier, ChangeCountryState>(
  (ref) {
    final updateUserProfileUsecase =
        ref.watch(updateUserProfileUseCaseProvider);
    return ChangeCountryNotifier(
      ChangeCountryState(),
      updateUserProfileUsecase,
    );
  },
);

class ChangeCountryNotifier extends StateNotifier<ChangeCountryState> {
  final UpdateUserProfileUsecase _updateUserProfile;
  ChangeCountryNotifier(super.state, this._updateUserProfile);

  Future<void> changeCountry(
      {required int countryId,
      required String countryName,
      required String userid}) async {
    state = state.copyWith(
        status: ChangeCountryStatus.changing, errorMessage: null);

    final updatedProfile = UserUpdateRequest(countryId: countryId, id: userid);

    final result = await _updateUserProfile(
      UpdateUserProfileParams(profile: updatedProfile),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ChangeCountryStatus.failure,
          errorMessage: 'Failed to change country',
        );
      },
      (response) {
        state = state.copyWith(status: ChangeCountryStatus.success);
      },
    );
  }
}
