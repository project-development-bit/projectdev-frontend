import 'package:cointiply_app/features/user_profile/domain/usecases/delete_account_usecase.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DeleteAccountStatus { initial, loading, success, failure }

class DeleteAccountState {
  final DeleteAccountStatus status;
  final String? errorMessage;
  final String? successMessage;

  bool get isDeleting => status == DeleteAccountStatus.loading;
  bool get hasError => status == DeleteAccountStatus.failure;
  bool get isSuccess => status == DeleteAccountStatus.success;

  DeleteAccountState({
    this.status = DeleteAccountStatus.initial,
    this.errorMessage,
    this.successMessage,
  });
}

final deleteAccountNotifierProvider =
    StateNotifierProvider.autoDispose<DeleteAccountNotifier, DeleteAccountState>(
        (ref) {
  final deleteAccountUsecase = ref.read(deleteAccountUseCaseProvider);
  return DeleteAccountNotifier(deleteAccountUsecase);
});

class DeleteAccountNotifier extends StateNotifier<DeleteAccountState> {
  final DeleteAccountUsecase deleteAccountUsecase;
  
  DeleteAccountNotifier(this.deleteAccountUsecase) 
      : super(DeleteAccountState());

  Future<void> deleteAccount({
    required String userId,
  }) async {
    state = DeleteAccountState(status: DeleteAccountStatus.loading);

    final params = DeleteAccountParams(userId: userId);

    final result = await deleteAccountUsecase(params);

    result.fold(
      (failure) {
        state = DeleteAccountState(
          status: DeleteAccountStatus.failure,
          errorMessage: failure.message ?? 'Failed to delete account. Please try again.',
        );
      },
      (response) {
        state = DeleteAccountState(
          status: DeleteAccountStatus.success,
          successMessage: response.message,
        );
      },
    );
  }

  void reset() {
    state = DeleteAccountState();
  }
}
