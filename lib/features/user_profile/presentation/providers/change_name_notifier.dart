import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/legacy.dart';

enum ChangeNameStatus { initial, loading, success, failure }

class ChangeNameState {
  final ChangeNameStatus status;
  final String? errorMessage;

  bool get isChanging => status == ChangeNameStatus.loading;
  bool get hasError => status == ChangeNameStatus.failure;

  ChangeNameState({
    this.status = ChangeNameStatus.initial,
    this.errorMessage,
  });
}

final changeNameNotifierProvider =
    StateNotifierProvider.autoDispose<ChangeNameNotifier, ChangeNameState>(
        (ref) {
  final updateUserProfileUsecase = ref.read(updateUserProfileUseCaseProvider);
  return ChangeNameNotifier(updateUserProfileUsecase);
});

class ChangeNameNotifier extends StateNotifier<ChangeNameState> {
  final UpdateUserProfileUsecase updateUserProfileUsecase;
  ChangeNameNotifier(this.updateUserProfileUsecase) : super(ChangeNameState());

  Future<void> changeName(
    String userId,
    String newName,
  ) async {
    state = ChangeNameState(status: ChangeNameStatus.loading);

    final profileUpdateRequest = UserUpdateRequest(name: newName, id: userId);
    final result = await updateUserProfileUsecase(
        UpdateUserProfileParams(profile: profileUpdateRequest));

    result.fold(
      (failure) {
        state = ChangeNameState(
          status: ChangeNameStatus.failure,
          errorMessage: 'Failed to change name. Please try again.',
        );
      },
      (response) {
        state = ChangeNameState(status: ChangeNameStatus.success);
      },
    );
  }
}
