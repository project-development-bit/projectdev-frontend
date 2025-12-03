import 'package:cointiply_app/features/user_profile/domain/usecases/verify_email_change_usecase.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum VerifyEmailChangeStatus { initial, verifying, success, failure }

class VerifyEmailChangeState {
  final VerifyEmailChangeStatus status;
  final String? message;

  bool get isVerifying => status == VerifyEmailChangeStatus.verifying;
  bool get hasError => status == VerifyEmailChangeStatus.failure;

  VerifyEmailChangeState(
      {this.status = VerifyEmailChangeStatus.initial, this.message});

  VerifyEmailChangeState copyWith(
      {VerifyEmailChangeStatus? status, String? message}) {
    return VerifyEmailChangeState(
        status: status ?? this.status, message: message ?? this.message);
  }
}

final verifyEmailChangeProvider =
    StateNotifierProvider<VerifyEmailChangeNotifier, VerifyEmailChangeState>(
        (ref) {
  final usecase = ref.watch(verifyEmailChangeUseCaseProvider);
  return VerifyEmailChangeNotifier(VerifyEmailChangeState(), usecase);
});

class VerifyEmailChangeNotifier extends StateNotifier<VerifyEmailChangeState> {
  final VerifyEmailChangeUsecase _usecase;

  VerifyEmailChangeNotifier(super.state, this._usecase);

  Future<void> verifyEmailChange(
      {required String email, required String code}) async {
    state = state.copyWith(
        status: VerifyEmailChangeStatus.verifying, message: null);

    final result =
        await _usecase.call(VerifyEmailChangeParams(email: email, code: code));

    result.fold((failure) {
      state = state.copyWith(
          status: VerifyEmailChangeStatus.failure,
          message: failure.message ?? 'Failed to verify email change');
    }, (response) {
      state = state.copyWith(
          status: VerifyEmailChangeStatus.success, message: response.message);
    });
  }
}
