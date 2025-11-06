import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/setup_2fa_request.dart';
import '../../data/models/setup_2fa_response.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../domain/usecases/setup_2fa_usecase.dart';

/// Provider for the Setup2FA use case
final setup2FAUseCaseProvider = Provider<Setup2FAUseCase>((ref) {
  return Setup2FAUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for the Setup2FA state notifier
final setup2FAProvider =
    StateNotifierProvider<Setup2FANotifier, Setup2FAState>((ref) {
  return Setup2FANotifier(ref.watch(setup2FAUseCaseProvider));
});

/// State for the 2FA setup process
abstract class Setup2FAState {
  const Setup2FAState();
}

/// Initial state - no setup attempted yet
class Setup2FAInitial extends Setup2FAState {
  const Setup2FAInitial();
}

/// Loading state - setup request is in progress
class Setup2FALoading extends Setup2FAState {
  const Setup2FALoading();
}

/// Success state - setup completed, QR code and secret received
class Setup2FASuccess extends Setup2FAState {
  final Setup2FAData data;

  const Setup2FASuccess(this.data);
}

/// Error state - setup failed with error message
class Setup2FAError extends Setup2FAState {
  final String message;

  const Setup2FAError(this.message);
}

/// State notifier for managing 2FA setup state
class Setup2FANotifier extends StateNotifier<Setup2FAState> {
  final Setup2FAUseCase _setup2FAUseCase;

  Setup2FANotifier(this._setup2FAUseCase) : super(const Setup2FAInitial());

  /// Setup 2FA for the authenticated user
  /// 
  /// This method calls the API to generate:
  /// - secret: The secret key for manual entry
  /// - qrCode: Base64 encoded PNG image for scanning
  /// - otpauthUrl: URL format for authenticator apps
  Future<void> setup2FA() async {
    state = const Setup2FALoading();

    final request = Setup2FARequest();
    final result = await _setup2FAUseCase(Setup2FAParams(request: request));

    result.fold(
      (failure) => state = Setup2FAError(failure.message ?? 'Failed to setup 2FA'),
      (response) {
        if (response.success && response.data != null) {
          state = Setup2FASuccess(response.data!);
        } else {
          state = const Setup2FAError('Failed to setup 2FA');
        }
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const Setup2FAInitial();
  }
}
