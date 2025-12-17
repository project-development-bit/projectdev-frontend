import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

/// Social login state classes
@immutable
sealed class SocialLoginState {
  const SocialLoginState();
}

/// Initial state for social login
class SocialLoginInitial extends SocialLoginState {
  const SocialLoginInitial();
}

/// Social login loading state
class SocialLoginLoading extends SocialLoginState {
  const SocialLoginLoading();
}

/// Social login success state
class SocialLoginSuccess extends SocialLoginState {
  final fb_auth.User user;

  const SocialLoginSuccess({required this.user});
}

/// Social login error state
class SocialLoginError extends SocialLoginState {
  final String message;

  const SocialLoginError({required this.message});
}

/// Social login notifier for managing social login operations
class SocialLoginNotifier extends StateNotifier<SocialLoginState> {
  final Ref _ref;

  SocialLoginNotifier(this._ref) : super(const SocialLoginInitial());

  /// Handle Google sign-in
  Future<void> googleSignIn() async {
    state = const SocialLoginLoading();
    try {
      final result =
          await _ref.read(googleSignInUseCaseProvider).call(NoParams());

      result.fold(
        (failure) {
          state = SocialLoginError(message: failure.message ?? "");
        },
        (user) {
          state = SocialLoginSuccess(user: user);
        },
      );
    } catch (e) {
      state = const SocialLoginError(message: "Google sign-in failed");
    }
  }
}

final socialLoginNotifierProvider =
    StateNotifierProvider<SocialLoginNotifier, SocialLoginState>((ref) {
  return SocialLoginNotifier(ref);
});
