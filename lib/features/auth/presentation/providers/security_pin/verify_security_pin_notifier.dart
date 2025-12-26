import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/auth/domain/usecases/verify_security_pin_usecase.dart';

enum VerifySecurityPinStatus { initial, loading, success, failure }

class VerifySecurityPinState {
  final VerifySecurityPinStatus status;
  final String? errorMessage;
  final String? successMessage;
  final bool? verified;

  bool get isLoaing => status == VerifySecurityPinStatus.loading;
  bool get hasError => status == VerifySecurityPinStatus.failure;
  bool get isSuccess => status == VerifySecurityPinStatus.success;

  VerifySecurityPinState({
    this.status = VerifySecurityPinStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.verified,
  });
}

class VerifySecurityPinNotifier extends StateNotifier<VerifySecurityPinState> {
  final VerifySecurityPinUsecase verifySecurityPinUsecase;

  VerifySecurityPinNotifier(this.verifySecurityPinUsecase)
      : super(VerifySecurityPinState());

  Future<void> verifySecurityPin({
    required int securityPin,
    Function()? onVerified,
  }) async {
    state = VerifySecurityPinState(status: VerifySecurityPinStatus.loading);

    final params = VerifySecurityPinParams(
      securityPin: securityPin,
    );

    final result = await verifySecurityPinUsecase(params);

    result.fold(
      (failure) {
        state = VerifySecurityPinState(
          status: VerifySecurityPinStatus.failure,
          errorMessage: failure.message ??
              'Failed to verify security PIN. Please try again.',
        );
      },
      (response) {
        state = VerifySecurityPinState(
          status: VerifySecurityPinStatus.success,
          successMessage: response.message,
          verified: response.verified,
        );
        if (response.verified == true) {
          onVerified?.call();
        }
      },
    );
  }

  void reset() {
    state = VerifySecurityPinState();
  }
}
