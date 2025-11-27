import 'package:cointiply_app/features/user_profile/domain/usecases/change_email_usecase.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChangeEmailStatus { initial, changing, success, failure }

class ChangeEmailState {
  final ChangeEmailStatus status;
  final String? errorMessage;
  final String? newEmail;

  bool get isChanging => status == ChangeEmailStatus.changing;
  bool get hasError => status == ChangeEmailStatus.failure;

  ChangeEmailState({this.status = ChangeEmailStatus.initial, this.errorMessage, this.newEmail});

  ChangeEmailState copyWith({ChangeEmailStatus? status, String? errorMessage, String? newEmail}) {
    return ChangeEmailState(status: status ?? this.status, errorMessage: errorMessage ?? this.errorMessage, newEmail: newEmail ?? this.newEmail);
  }
}

final changeEmailProvider = StateNotifierProvider<ChangeEmailNotifier, ChangeEmailState>((ref) {
  final usecase = ref.watch(changeEmailUseCaseProvider);
  return ChangeEmailNotifier(ChangeEmailState(), usecase);
});

class ChangeEmailNotifier extends StateNotifier<ChangeEmailState> {
  final ChangeEmailUsecase _usecase;

  ChangeEmailNotifier(super.state, this._usecase);

  Future<void> changeEmail({required String currentEmail, required String newEmail, required String repeatNewEmail}) async {
    state = state.copyWith(status: ChangeEmailStatus.changing, errorMessage: null);

    final result = await _usecase.call(ChangeEmailParams(currentEmail: currentEmail, newEmail: newEmail, repeatNewEmail: repeatNewEmail));

    result.fold((failure) {
      state = state.copyWith(status: ChangeEmailStatus.failure, errorMessage: failure.message ?? 'Failed to change email');
    }, (response) {
      state = state.copyWith(status: ChangeEmailStatus.success, newEmail: response.newEmail);
    });
  }
}