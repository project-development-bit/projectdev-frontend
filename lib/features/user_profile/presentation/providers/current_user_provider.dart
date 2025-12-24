import 'package:cointiply_app/features/localization/presentation/providers/get_languages_state.dart';
import 'package:cointiply_app/features/localization/presentation/providers/localization_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/login_provider.dart';

/// State for user data management in profile context
class CurrentUserState {
  final User? user;
  final bool isLoading;
  final String? error;

  const CurrentUserState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  CurrentUserState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return CurrentUserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier for managing current user state in profile context
class CurrentUserNotifier extends StateNotifier<CurrentUserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  final Ref _ref;

  CurrentUserNotifier(this._getCurrentUserUseCase, this._ref)
      : super(const CurrentUserState());

  /// Get current user from API (whoami)
  Future<void> getCurrentUser({bool isLoading = true}) async {
    state = state.copyWith(isLoading: isLoading, error: null);

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) {
        String errorMessage = 'Failed to get user information';
        if (failure is ServerFailure) {
          errorMessage = failure.message ?? 'Server error occurred';
        } else if (failure is NetworkFailure) {
          errorMessage = 'Network error. Please check your connection.';
        } else if (failure is AuthenticationFailure) {
          errorMessage = 'Authentication failed. Please login again.';
        }
        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );
      },
      (user) {
        _ref.read(localizationNotifierProvider.notifier).changeLocale(
              _ref
                  .read(getLanguagesNotifierProvider)
                  .getLocateByLanguageCode(user.language),
              userid: user.id.toString(),
            );

        state = state.copyWith(
          user: user,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  /// Initialize user from login state if available, otherwise fetch from API
  /// Only fetches from API if user is authenticated
  Future<void> initializeUser() async {
    // Check if user is authenticated first
    final isAuthenticated = _ref.read(isAuthenticatedObservableProvider);
    if (!isAuthenticated) {
      // Clear any existing user data and don't make API call
      state = const CurrentUserState();
      return;
    }

    // First check if we have user from login
    final loggedInUser = _ref.read(loggedInUserProvider);
    if (loggedInUser != null) {
      state = state.copyWith(user: loggedInUser, error: null);
      return;
    }

    // If no logged in user but authenticated, try to fetch from API
    await getCurrentUser();
  }

  /// Refresh user data from API
  Future<void> refreshUser() async {
    debugPrint('Refreshing current user data...');
    await getCurrentUser(isLoading: false);
  }

  /// Clear user data (for logout)
  void clearUser() {
    state = const CurrentUserState();
  }

  /// Update user data locally
  void updateUser(User user) {
    state = state.copyWith(user: user, error: null);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Update profile locally (optimistic update)
  void updateProfileLocally(User user) {
    state = state.copyWith(
      user: user,
    );
  }
}

/// Provider for current user state management in profile context
final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, CurrentUserState>((ref) {
  final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
  return CurrentUserNotifier(getCurrentUserUseCase, ref);
});

/// Convenience provider to get current user
final profileCurrentUserProvider = Provider<User?>((ref) {
  return ref.watch(currentUserProvider).user;
});

/// Convenience provider to check if user is loading
final isCurrentUserLoadingProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider).isLoading;
});

/// Convenience provider to get user error
final currentUserErrorProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider).error;
});
