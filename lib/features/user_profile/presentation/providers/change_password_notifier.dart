import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/user_profile/domain/usecases/change_password_usecase.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String? errorMessage;

  bool get isChanging => status == ChangePasswordStatus.loading;
  bool get hasError => status == ChangePasswordStatus.failure;

  ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
  });
}

final changePasswordNotifierProvider = StateNotifierProvider.autoDispose<
    ChangePasswordNotifier, ChangePasswordState>((ref) {
  final changePasswordUsecase = ref.read(changePasswordUseCaseProvider);
  final secureStorageService = ref.read(secureStorageServiceProvider);
  return ChangePasswordNotifier(changePasswordUsecase, secureStorageService);
});

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  final ChangePasswordUsecase changePasswordUsecase;
  final SecureStorageService secureStorageService;
  ChangePasswordNotifier(this.changePasswordUsecase, this.secureStorageService)
      : super(ChangePasswordState());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String repeatNewPassword,
  }) async {
    state = ChangePasswordState(status: ChangePasswordStatus.loading);

    final params = ChangePasswordParams(
      currentPassword: currentPassword,
      newPassword: newPassword,
      repeatNewPassword: repeatNewPassword,
    );

    final result = await changePasswordUsecase(params);

    result.fold(
      (failure) {
        state = ChangePasswordState(
          status: ChangePasswordStatus.failure,
          errorMessage:
              failure.message ?? 'Failed to change password. Please try again.',
        );
      },
      (response) async {
        state = ChangePasswordState(status: ChangePasswordStatus.success);

        await secureStorageService.savePasswords(password: newPassword);
      },
    );
  }
}
