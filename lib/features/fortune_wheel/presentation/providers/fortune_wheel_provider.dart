import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/fortune_wheel_reward.dart';
import '../../domain/entities/fortune_wheel_spin_response.dart';
import '../../domain/entities/fortune_wheel_status.dart';
import '../../domain/usecases/get_fortune_wheel_rewards_usecase.dart';
import '../../domain/usecases/spin_fortune_wheel_usecase.dart';
import '../../domain/usecases/get_fortune_wheel_status_usecase.dart';
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

/// Fortune wheel spinning state
class FortuneWheelSpinning extends FortuneWheelState {
  const FortuneWheelSpinning(this.rewards);

  final List<FortuneWheelReward> rewards;
}

/// Fortune wheel spin success state
class FortuneWheelSpinSuccess extends FortuneWheelState {
  const FortuneWheelSpinSuccess({
    required this.rewards,
    required this.spinResponse,
  });

  final List<FortuneWheelReward> rewards;
  final FortuneWheelSpinResponse spinResponse;
}

// =============================================================================
// FORTUNE WHEEL STATUS STATE CLASSES
// =============================================================================

/// Fortune wheel status state
@immutable
sealed class FortuneWheelStatusState {
  const FortuneWheelStatusState();
}

/// Initial status state
class FortuneWheelStatusInitial extends FortuneWheelStatusState {
  const FortuneWheelStatusInitial();
}

/// Status loading
class FortuneWheelStatusLoading extends FortuneWheelStatusState {
  const FortuneWheelStatusLoading();
}

/// Status loaded successfully
class FortuneWheelStatusLoaded extends FortuneWheelStatusState {
  const FortuneWheelStatusLoaded(this.status);

  final FortuneWheelStatus status;
}

/// Status error
class FortuneWheelStatusError extends FortuneWheelStatusState {
  const FortuneWheelStatusError(this.message);

  final String message;
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
          final isNetworkError =
              failure is ServerFailure && failure.statusCode == null;

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

  /// Spin the fortune wheel
  Future<void> spinFortuneWheel({
    Function(String)? onSuccess,
    Function(String)? onError,
    Function(int)? onSpinResult,
  }) async {
    debugPrint('🎡 Starting spin fortune wheel');

    // Ensure we have rewards loaded first
    if (state is! FortuneWheelLoaded && state is! FortuneWheelSpinSuccess) {
      debugPrint('🎡 Rewards not loaded, cannot spin');
      onError?.call('Please wait for rewards to load');
      return;
    }

    final currentRewards = state is FortuneWheelLoaded
        ? (state as FortuneWheelLoaded).rewards
        : (state as FortuneWheelSpinSuccess).rewards;

    // Set spinning state
    state = FortuneWheelSpinning(currentRewards);

    // await Future.delayed(const Duration(seconds: 1), () {
    //   onSpinResult?.call(2);
    //   onSuccess?.call();
    // }); // Simulate network delay
    // return;

    try {
      final useCase = SpinFortuneWheelUseCase(
        _ref.read(fortuneWheelRepositoryProvider),
      );

      final result = await useCase.call(NoParams());

      result.fold(
        (failure) {
          debugPrint('🎡 Failed to spin: ${failure.message}');

          // Return to loaded state on error
          state = FortuneWheelLoaded(currentRewards);

          onError?.call(failure.message ?? 'Failed to spin wheel');
        },
        (spinResponse) {
          debugPrint(
              '🎡 Spin successful - Wheel Index: ${spinResponse.wheelIndex}');
          debugPrint('🎡 Message: ${spinResponse.message}');
          debugPrint(
              '🎡 Remaining Daily Cap: ${spinResponse.remainingDailyCap}');
          onSpinResult?.call(spinResponse.wheelIndex);

          Future.delayed(const Duration(seconds: 6), () async {
            state = FortuneWheelSpinSuccess(
              rewards: currentRewards,
              spinResponse: spinResponse,
            );
            onSuccess?.call(spinResponse.message);
          });
        },
      );
    } catch (e) {
      debugPrint('🎡 Unexpected error during spin: $e');

      // Return to loaded state on error
      state = FortuneWheelLoaded(currentRewards);

      onError?.call('An unexpected error occurred');
    }
  }

  /// Reset to initial state
  void reset() {
    state = const FortuneWheelInitial();
  }

  /// Reset to loaded state after spin
  void resetToLoaded() {
    if (state is FortuneWheelSpinSuccess) {
      final currentState = state as FortuneWheelSpinSuccess;
      state = FortuneWheelLoaded(currentState.rewards);
    }
  }
}

// =============================================================================
// FORTUNE WHEEL STATUS STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing fortune wheel status
class FortuneWheelStatusNotifier
    extends StateNotifier<FortuneWheelStatusState> {
  FortuneWheelStatusNotifier(this._ref)
      : super(const FortuneWheelStatusInitial());

  final Ref _ref;

  /// Fetch fortune wheel status
  Future<void> fetchFortuneWheelStatus({
    VoidCallback? onSuccess,
    Function(String)? onError,
    Function(FortuneWheelStatus)? onStatusFetched,
  }) async {
    debugPrint('🎡 Starting fetch fortune wheel status');
    debugPrint('🎡 Current status state: ${state.runtimeType}');

    state = const FortuneWheelStatusLoading();

    try {
      final useCase = GetFortuneWheelStatusUseCase(
        _ref.read(fortuneWheelRepositoryProvider),
      );

      final result = await useCase.call(NoParams());

      result.fold(
        (failure) {
          debugPrint('🎡 Failed to fetch status: ${failure.message}');
          state = FortuneWheelStatusError(
            failure.message ?? 'Failed to load fortune wheel status',
          );
          onError?.call(failure.message ?? 'Failed to load status');
        },
        (status) {
          debugPrint('🎡 Successfully fetched status');
          debugPrint('🎡 Can Spin: ${status.canSpin}');
          debugPrint('🎡 Base Spins: ${status.spins.base}');
          debugPrint('🎡 Bonus Spins: ${status.spins.bonus}');
          debugPrint('🎡 Total Spins: ${status.spins.total}');
          debugPrint('🎡 Daily Limit: ${status.dailyLimit}');

          state = FortuneWheelStatusLoaded(status);
          onStatusFetched?.call(status);
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('🎡 Unexpected error: $e');
      state = const FortuneWheelStatusError('An unexpected error occurred');
      onError?.call('An unexpected error occurred');
    }
  }

  /// Reset status to initial state
  void reset() {
    state = const FortuneWheelStatusInitial();
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

/// Provider for fortune wheel status state
final fortuneWheelStatusProvider =
    StateNotifierProvider<FortuneWheelStatusNotifier, FortuneWheelStatusState>(
  (ref) => FortuneWheelStatusNotifier(ref),
);
