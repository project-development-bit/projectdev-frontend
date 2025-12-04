import 'package:cointiply_app/features/user_profile/domain/usecases/verify_delete_account_usecase.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum VerifyDeleteAccountStatus { initial, loading, success, failure }

class VerifyDeleteAccountState {
  final VerifyDeleteAccountStatus status;
  final String? errorMessage;
  final String? successMessage;
  final int? deletedUserId;
  final String? deletedEmail;

  bool get isVerifying => status == VerifyDeleteAccountStatus.loading;
  bool get hasError => status == VerifyDeleteAccountStatus.failure;
  bool get isSuccess => status == VerifyDeleteAccountStatus.success;

  VerifyDeleteAccountState({
    this.status = VerifyDeleteAccountStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.deletedUserId,
    this.deletedEmail,
  });
}

final verifyDeleteAccountNotifierProvider = StateNotifierProvider.autoDispose<
    VerifyDeleteAccountNotifier, VerifyDeleteAccountState>((ref) {
  final verifyDeleteAccountUsecase =
      ref.read(verifyDeleteAccountUseCaseProvider);
  return VerifyDeleteAccountNotifier(verifyDeleteAccountUsecase);
});

class VerifyDeleteAccountNotifier
    extends StateNotifier<VerifyDeleteAccountState> {
  final VerifyDeleteAccountUsecase verifyDeleteAccountUsecase;

  VerifyDeleteAccountNotifier(this.verifyDeleteAccountUsecase)
      : super(VerifyDeleteAccountState());

  Future<void> verifyDeleteAccount({
    required String code,
  }) async {
    state = VerifyDeleteAccountState(status: VerifyDeleteAccountStatus.loading);

    final params = VerifyDeleteAccountParams(code: code);

    final result = await verifyDeleteAccountUsecase(params);

    result.fold(
      (failure) {
        state = VerifyDeleteAccountState(
          status: VerifyDeleteAccountStatus.failure,
          errorMessage: failure.message ??
              'Failed to verify account deletion. Please try again.',
        );
      },
      (response) {
        state = VerifyDeleteAccountState(
          status: VerifyDeleteAccountStatus.success,
          successMessage: response.message,
          deletedUserId: response.deletedUserId,
          deletedEmail: response.deletedEmail,
        );
      },
    );
  }

  void reset() {
    state = VerifyDeleteAccountState();
  }
}
