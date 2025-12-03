import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/verify_login_2fa_request.dart';
import '../../data/models/verify_login_2fa_response.dart';
import '../../domain/usecases/verify_login_2fa_usecase.dart';

/// Provider for the Verify Login 2FA state notifier
final verifyLogin2FAProvider =
    StateNotifierProvider<VerifyLogin2FANotifier, VerifyLogin2FAState>(
  (ref) => VerifyLogin2FANotifier(ref.watch(verifyLogin2FAUseCaseProvider)),
);

/// State for Verify Login 2FA
@immutable
sealed class VerifyLogin2FAState {
  const VerifyLogin2FAState();
}

/// Initial state
class VerifyLogin2FAInitial extends VerifyLogin2FAState {
  const VerifyLogin2FAInitial();
}

/// Loading state
class VerifyLogin2FALoading extends VerifyLogin2FAState {
  const VerifyLogin2FALoading();
}

/// Success state with login response
class VerifyLogin2FASuccess extends VerifyLogin2FAState {
  final VerifyLogin2FAResponse response;

  const VerifyLogin2FASuccess({required this.response});
}

/// Error state
class VerifyLogin2FAError extends VerifyLogin2FAState {
  final String message;

  const VerifyLogin2FAError(this.message);
}

/// State notifier for verifying 2FA code during login
class VerifyLogin2FANotifier extends StateNotifier<VerifyLogin2FAState> {
  final VerifyLogin2FAUseCase _verifyLogin2FAUseCase;

  VerifyLogin2FANotifier(this._verifyLogin2FAUseCase)
      : super(const VerifyLogin2FAInitial());

  /// Verify 2FA code during login
  Future<void> verifyLogin2FA({
    required String token,
    required int userId,
  }) async {
    state = const VerifyLogin2FALoading();

    debugPrint('🔐 Verifying 2FA code for login...');
    debugPrint('Token: $token, UserId: $userId');

    final request = VerifyLogin2FARequest(token: token, userId: userId);
    final result = await _verifyLogin2FAUseCase(request);

    result.fold(
      (failure) {
        debugPrint('❌ Verify Login 2FA failed: ${failure.message}');
        state =
            VerifyLogin2FAError(failure.message ?? 'Failed to verify 2FA code');
      },
      (response) {
        debugPrint('✅ Verify Login 2FA successful: ${response.message}');
        state = VerifyLogin2FASuccess(response: response);
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const VerifyLogin2FAInitial();
  }
}
