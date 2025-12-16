import 'package:cointiply_app/core/providers/turnstile_provider.dart';
import 'package:cointiply_app/core/services/device_info.dart';
import 'package:cointiply_app/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:cointiply_app/features/faucet/domain/usecases/claim_faucet_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'claim_faucet_state.dart';

class ClaimFaucetNotifier extends StateNotifier<ClaimFaucetState> {
  final ClaimFaucetUseCase _claimFaucetUseCase;
  final Ref _ref;
  final DeviceInfo _deviceInfo;

  ClaimFaucetNotifier(this._claimFaucetUseCase, this._ref, this._deviceInfo)
      : super(const ClaimFaucetState());

  Future<void> claim() async {
    state = state.copyWith(status: ClaimFaucetStatus.loading);

    String? turnstileToken;

    debugPrint('🔐 Checking Turnstile verification...');
    final turnstileState =
        _ref.read(turnstileNotifierProvider(TurnstileActionEnum.claimFaucet));

    if (turnstileState is TurnstileSuccess) {
      turnstileToken = turnstileState.token;
      debugPrint('✅ Turnstile token obtained successfully');
    } else {
      debugPrint('❌ Turnstile verification incomplete');
      state = const ClaimFaucetState(
        error:
            'Security verification required. Please complete the verification and try again.',
      );
      return;
    }

    final result = await _claimFaucetUseCase.call(
      ClaimFaucetRequestModel(
        turnstileToken: turnstileToken,
        deviceFingerprint: await _deviceInfo.getUniqueIdentifier() ?? '',
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
        Future.delayed(
          const Duration(seconds: 1),
          () {
            state = state.copyWith(status: ClaimFaucetStatus.success);
          },
        );
      },
    );
  }

  void reset() {
    state = const ClaimFaucetState();
  }
}
