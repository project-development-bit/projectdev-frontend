import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/models/check_2fa_status_response.dart';
import '../../domain/usecases/check_2fa_status_usecase.dart';

/// Provider for the Check 2FA Status state notifier
final check2FAStatusProvider =
    StateNotifierProvider<Check2FAStatusNotifier, Check2FAStatusState>(
  (ref) => Check2FAStatusNotifier(ref.watch(check2FAStatusUseCaseProvider)),
);

/// State for Check 2FA Status
@immutable
sealed class Check2FAStatusState {
  const Check2FAStatusState();
}

/// Initial state
class Check2FAStatusInitial extends Check2FAStatusState {
  const Check2FAStatusInitial();
}

/// Loading state
class Check2FAStatusLoading extends Check2FAStatusState {
  const Check2FAStatusLoading();
}

/// Success state with 2FA status data
class Check2FAStatusSuccess extends Check2FAStatusState {
  final Check2FAStatusResponse response;
  final bool is2FAEnabled;

  const Check2FAStatusSuccess({
    required this.response,
    required this.is2FAEnabled,
  });
}

/// Error state
class Check2FAStatusError extends Check2FAStatusState {
  final String message;

  const Check2FAStatusError(this.message);
}

/// State notifier for checking 2FA status
class Check2FAStatusNotifier extends StateNotifier<Check2FAStatusState> {
  final Check2FAStatusUseCase _check2FAStatusUseCase;

  Check2FAStatusNotifier(this._check2FAStatusUseCase)
      : super(const Check2FAStatusInitial());

  /// Check if 2FA is enabled for the authenticated user
  Future<void> check2FAStatus() async {
    state = const Check2FAStatusLoading();

    debugPrint('🔐 Checking 2FA status...');

    final result = await _check2FAStatusUseCase(NoParams());

    result.fold(
      (failure) {
        debugPrint('❌ Check 2FA status failed: ${failure.message}');
        state = Check2FAStatusError(
            failure.message ?? 'Failed to check 2FA status');
      },
      (response) {
        final is2FAEnabled = response.data?.twofaEnabled ?? false;
        debugPrint(
            '✅ 2FA status checked successfully: ${is2FAEnabled ? "Enabled" : "Disabled"}');
        state = Check2FAStatusSuccess(
          response: response,
          is2FAEnabled: is2FAEnabled,
        );
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const Check2FAStatusInitial();
  }
}
