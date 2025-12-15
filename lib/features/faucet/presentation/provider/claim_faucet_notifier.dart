import 'package:cointiply_app/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:cointiply_app/features/faucet/domain/usecases/claim_faucet_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'claim_faucet_state.dart';

class ClaimFaucetNotifier extends StateNotifier<ClaimFaucetState> {
  final ClaimFaucetUseCase _claimFaucetUseCase;

  ClaimFaucetNotifier(this._claimFaucetUseCase)
      : super(const ClaimFaucetState());

  Future<void> claim({
    required String deviceFingerprint,
    required String turnstileToken,
  }) async {
    state = state.copyWith(status: ClaimFaucetStatus.loading);

    final result = await _claimFaucetUseCase.call(
      ClaimFaucetRequestModel(
        deviceFingerprint: deviceFingerprint,
        turnstileToken: turnstileToken,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ClaimFaucetStatus.error,
          error: failure.message,
        );
      },
      (_) {
        state = state.copyWith(status: ClaimFaucetStatus.success);
      },
    );
  }

  void reset() {
    state = const ClaimFaucetState();
  }
}
