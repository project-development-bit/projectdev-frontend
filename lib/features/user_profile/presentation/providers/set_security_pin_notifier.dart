import 'package:gigafaucet/features/user_profile/domain/usecases/set_security_pin_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SetSecurityPinStatus { initial, loading, success, failure }

class SetSecurityPinState {
  final SetSecurityPinStatus status;
  final String? errorMessage;
  final String? successMessage;
  final bool? securityPinEnabled;

  bool get isSetting => status == SetSecurityPinStatus.loading;
  bool get hasError => status == SetSecurityPinStatus.failure;
  bool get isSuccess => status == SetSecurityPinStatus.success;

  SetSecurityPinState({
    this.status = SetSecurityPinStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.securityPinEnabled,
  });
}

class SetSecurityPinNotifier extends StateNotifier<SetSecurityPinState> {
  final SetSecurityPinUsecase setSecurityPinUsecase;

  SetSecurityPinNotifier(this.setSecurityPinUsecase)
      : super(SetSecurityPinState());

  Future<void> setSecurityPin({
    required int securityPin,
    required bool enable,
  }) async {
    state = SetSecurityPinState(status: SetSecurityPinStatus.loading);

    final params = SetSecurityPinParams(
      securityPin: securityPin,
      enable: enable,
    );

    final result = await setSecurityPinUsecase(params);

    result.fold(
      (failure) {
        state = SetSecurityPinState(
          status: SetSecurityPinStatus.failure,
          errorMessage: failure.message ??
              'Failed to set security PIN. Please try again.',
        );
      },
      (response) {
        state = SetSecurityPinState(
          status: SetSecurityPinStatus.success,
          successMessage: response.message,
          securityPinEnabled: response.securityPinEnabled,
        );
      },
    );
  }

  void reset() {
    state = SetSecurityPinState();
  }
}
