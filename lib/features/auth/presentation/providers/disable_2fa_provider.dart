import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/models/disable_2fa_request.dart';
import '../../data/models/disable_2fa_response.dart';
import '../../domain/usecases/disable_2fa_usecase.dart';

/// Provider for the Disable 2FA state notifier
final disable2FAProvider =
    StateNotifierProvider<Disable2FANotifier, Disable2FAState>(
  (ref) => Disable2FANotifier(ref.watch(disable2FAUseCaseProvider)),
);

/// State for Disable 2FA
@immutable
sealed class Disable2FAState {
  const Disable2FAState();
}

/// Initial state
class Disable2FAInitial extends Disable2FAState {
  const Disable2FAInitial();
}

/// Loading state
class Disable2FALoading extends Disable2FAState {
  const Disable2FALoading();
}

/// Success state with disable response
class Disable2FASuccess extends Disable2FAState {
  final Disable2FAResponse response;

  const Disable2FASuccess({required this.response});
}

/// Error state
class Disable2FAError extends Disable2FAState {
  final String message;

  const Disable2FAError(this.message);
}

/// State notifier for disabling 2FA
class Disable2FANotifier extends StateNotifier<Disable2FAState> {
  final Disable2FAUseCase _disable2FAUseCase;

  Disable2FANotifier(this._disable2FAUseCase)
      : super(const Disable2FAInitial());

  /// Disable 2FA for the authenticated user
  Future<void> disable2FA() async {
    state = const Disable2FALoading();

    debugPrint('🔐 Disabling 2FA...');

    final result = await _disable2FAUseCase(const Disable2FARequest());

    result.fold(
      (failure) {
        debugPrint('❌ Disable 2FA failed: ${failure.message}');
        state = Disable2FAError(failure.message ?? 'Failed to disable 2FA');
      },
      (response) {
        debugPrint('✅ 2FA disabled successfully: ${response.message}');
        state = Disable2FASuccess(response: response);
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const Disable2FAInitial();
  }
}
