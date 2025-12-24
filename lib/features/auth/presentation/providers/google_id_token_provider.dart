import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/auth/domain/usecases/get_platform_specific_id_token.dart';

enum GetGoogleIdTokenStatus {
  initial,
  loading,
  success,
  error,
}

enum GoogleSignInMethod {
  googleSignIn,
  googleSignUp,
}

class GoogleIdTokenState {
  final GetGoogleIdTokenStatus status;
  final String? token;
  final GoogleSignInMethod? signInMethod;
  final String? error;

  const GoogleIdTokenState({
    this.status = GetGoogleIdTokenStatus.initial,
    this.signInMethod,
    this.token,
    this.error,
  });

  GoogleIdTokenState copyWith({
    GetGoogleIdTokenStatus? status,
    GoogleSignInMethod? signInMethod,
    String? token,
    String? error,
  }) {
    return GoogleIdTokenState(
      status: status ?? this.status,
      signInMethod: signInMethod ?? this.signInMethod,
      token: token ?? this.token,
      error: error,
    );
  }
}

final googleIdTokenNotifierProvider =
    StateNotifierProvider<GoogleIdTokenNotifier, GoogleIdTokenState>(
  (ref) =>
      GoogleIdTokenNotifier(ref.watch(getGooglePlatformIdTokenUseCaseProvider)),
);

class GoogleIdTokenNotifier extends StateNotifier<GoogleIdTokenState> {
  final GetPlatformSpecificIdTokenUseCase getPlatformSpecificIdTokenUseCase;

  GoogleIdTokenNotifier(this.getPlatformSpecificIdTokenUseCase)
      : super(const GoogleIdTokenState());

  Future<void> getGoogleIdToken({GoogleSignInMethod? signInMethod}) async {
    if (state.status == GetGoogleIdTokenStatus.loading) {
      return;
    }

    state = state.copyWith(
        status: GetGoogleIdTokenStatus.loading,
        error: null,
        signInMethod: signInMethod);

    final result = await getPlatformSpecificIdTokenUseCase.call(NoParams());

    state = result.fold(
      (failure) => state.copyWith(
        status: GetGoogleIdTokenStatus.error,
        error: _mapFailureToMessage(failure),
      ),
      (token) => state.copyWith(
        status: GetGoogleIdTokenStatus.success,
        token: token,
        error: null,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Failed to get Google ID token';
    }
    return 'Unexpected error occurred';
  }
}
