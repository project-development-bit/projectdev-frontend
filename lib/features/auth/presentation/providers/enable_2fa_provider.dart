import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/enable_2fa_request.dart';
import '../../data/models/enable_2fa_response.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../domain/usecases/enable_2fa_usecase.dart';

/// Provider for the Enable2FA use case
final enable2FAUseCaseProvider = Provider<Enable2FAUseCase>((ref) {
  return Enable2FAUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for the Enable2FA state notifier
final enable2FAProvider =
    StateNotifierProvider<Enable2FANotifier, Enable2FAState>((ref) {
  return Enable2FANotifier(ref.watch(enable2FAUseCaseProvider));
});

/// Provider to check if 2FA enable is loading
final isEnable2FALoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(enable2FAProvider);
  return state is Enable2FALoading;
});

/// State for the 2FA enable process
abstract class Enable2FAState {
  const Enable2FAState();
}

/// Initial state - no enable attempted yet
class Enable2FAInitial extends Enable2FAState {
  const Enable2FAInitial();
}

/// Loading state - enable request is in progress
class Enable2FALoading extends Enable2FAState {
  const Enable2FALoading();
}

/// Success state - 2FA enabled successfully
class Enable2FASuccess extends Enable2FAState {
  final String message;
  final Enable2FAData data;

  const Enable2FASuccess({
    required this.message,
    required this.data,
  });
}

/// Error state - enable failed with error message
class Enable2FAError extends Enable2FAState {
  final String message;

  const Enable2FAError(this.message);
}

/// State notifier for managing 2FA enable state
class Enable2FANotifier extends StateNotifier<Enable2FAState> {
  final Enable2FAUseCase _enable2FAUseCase;

  Enable2FANotifier(this._enable2FAUseCase) : super(const Enable2FAInitial());

  /// Enable 2FA by verifying the token from authenticator app
  /// 
  /// This method calls the API to verify:
  /// - token: The 6-digit code from the authenticator app
  /// - secret: The secret key that was provided during setup
  Future<void> enable2FA({
    required String token,
    required String secret,
  }) async {
    state = const Enable2FALoading();

    final request = Enable2FARequest(token: token, secret: secret);
    final result = await _enable2FAUseCase(Enable2FAParams(request: request));

    result.fold(
      (failure) => state = Enable2FAError(failure.message ?? 'Failed to enable 2FA'),
      (response) {
        if (response.success && response.data != null) {
          state = Enable2FASuccess(
            message: response.message,
            data: response.data!,
          );
        } else {
          state = Enable2FAError(response.message);
        }
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const Enable2FAInitial();
  }
}
