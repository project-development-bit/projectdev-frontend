import 'package:gigafaucet/core/providers/turnstile_provider.dart';
import 'package:gigafaucet/core/services/device_info.dart';
import 'package:gigafaucet/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:gigafaucet/features/faucet/domain/usecases/claim_faucet_usecase.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/current_user_provider.dart';
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
        _ref.read(turnstileNotifierProvider(TurnstileActionEnum.faucetClaim));

    if (turnstileState is TurnstileSuccess) {
      turnstileToken = turnstileState.token;
      debugPrint('✅ Turnstile token obtained successfully');
    } else {
      debugPrint('❌ Turnstile verification incomplete');
      state = const ClaimFaucetState(
        error: 'You need to resolve a captcha to claim your faucet',
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
        _ref.read(getFaucetNotifierProvider.notifier).fetchFaucetStatus();
        _ref.read(currentUserProvider.notifier).getCurrentUser();
        state = state.copyWith(
          status: ClaimFaucetStatus.error,
          error: failure.message,
        );
      },
      (_) {
        _ref.read(getFaucetNotifierProvider.notifier).fetchFaucetStatus();
        _ref.read(currentUserProvider.notifier).getCurrentUser();
        state = state.copyWith(status: ClaimFaucetStatus.success);
      },
    );
  }

  void reset() {
    state = const ClaimFaucetState();
  }
}
