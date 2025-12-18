import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/fortune_wheel_reward.dart';
import '../../domain/usecases/get_fortune_wheel_rewards_usecase.dart';
import '../../data/repositories/fortune_wheel_repository_impl.dart';

// =============================================================================
// FORTUNE WHEEL STATE CLASSES
// =============================================================================

/// Fortune wheel state for the application
@immutable
sealed class FortuneWheelState {
  const FortuneWheelState();
}

/// Initial fortune wheel state
class FortuneWheelInitial extends FortuneWheelState {
  const FortuneWheelInitial();
}

/// Fortune wheel loading state
class FortuneWheelLoading extends FortuneWheelState {
  const FortuneWheelLoading();
}

/// Fortune wheel loaded successfully
class FortuneWheelLoaded extends FortuneWheelState {
  const FortuneWheelLoaded(this.rewards);

  final List<FortuneWheelReward> rewards;
}

/// Fortune wheel error state
class FortuneWheelError extends FortuneWheelState {
  const FortuneWheelError({
    required this.message,
    this.isNetworkError = false,
  });

  final String message;
  final bool isNetworkError;
}

// =============================================================================
// FORTUNE WHEEL STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing fortune wheel operations
class FortuneWheelNotifier extends StateNotifier<FortuneWheelState> {
  FortuneWheelNotifier(this._ref) : super(const FortuneWheelInitial());

  final Ref _ref;

  /// Fetch fortune wheel rewards
  Future<void> fetchFortuneWheelRewards({
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🎡 Starting fetch fortune wheel rewards');
    debugPrint('🎡 Current state: ${state.runtimeType}');

    state = const FortuneWheelLoading();

    try {
      final useCase = GetFortuneWheelRewardsUseCase(
        _ref.read(fortuneWheelRepositoryProvider),
      );

      final result = await useCase.call(NoParams());

      result.fold(
        (failure) {
          debugPrint('🎡 Failed to fetch rewards: ${failure.message}');
          
          // Check if it's a network error (ServerFailure without status code)
          final isNetworkError = failure is ServerFailure && failure.statusCode == null;
          
          state = FortuneWheelError(
            message: failure.message ?? 'Failed to load fortune wheel rewards',
            isNetworkError: isNetworkError,
          );
          onError?.call(failure.message ?? 'Failed to load rewards');
        },
        (rewards) {
          debugPrint('🎡 Successfully fetched ${rewards.length} rewards');
          state = FortuneWheelLoaded(rewards);
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('🎡 Unexpected error: $e');
      state = FortuneWheelError(
        message: 'An unexpected error occurred',
        isNetworkError: true,
      );
      onError?.call('An unexpected error occurred');
    }
  }

  /// Reset to initial state
  void reset() {
    state = const FortuneWheelInitial();
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Provider for fortune wheel state
final fortuneWheelProvider =
    StateNotifierProvider<FortuneWheelNotifier, FortuneWheelState>(
  (ref) => FortuneWheelNotifier(ref),
);
