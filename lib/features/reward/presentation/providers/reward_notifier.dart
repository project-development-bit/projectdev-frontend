import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_response.dart';
import 'package:cointiply_app/features/reward/domain/usecases/get_user_rewards_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reward_state.dart';

class RewardNotifier extends StateNotifier<RewardState> {
  final GetUserRewardsUseCase _usecase;

  RewardNotifier(this._usecase) : super(const RewardState()) {
    loadRewards();
  }

  Future<void> loadRewards() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _usecase(NoParams());

    result.fold(
      (failure) {
        String message = 'Failed to load rewards';

        if (failure is ServerFailure) {
          message = failure.message ?? 'Server error occurred';
        } else if (failure is NetworkFailure) {
          message = 'Network error. Check your connection.';
        } else if (failure is AuthenticationFailure) {
          message = 'Authentication failed. Please log in again.';
        }

        state = state.copyWith(
          isLoading: false,
          error: message,
        );
      },
      (rewardResponse) {
        state = state.copyWith(
          rewards: rewardResponse,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  /// Refresh rewards (pull-to-refresh, UI button)
  Future<void> refreshRewards() async {
    await loadRewards();
  }

  /// Optimistic local update (UI updates instantly)
  void updateRewardsLocally(RewardResponse rewards) {
    state = state.copyWith(rewards: rewards);
  }

  /// Clear only errors
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear all (logout / reset rewards)
  void clearRewards() {
    state = const RewardState();
  }
}
