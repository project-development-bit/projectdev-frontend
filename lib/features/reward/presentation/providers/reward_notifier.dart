// get_reward_notifier.dart

import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_response.dart';
import 'package:cointiply_app/features/reward/domain/usecases/get_user_rewards_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reward_state.dart';

class GetRewardNotifier extends StateNotifier<RewardState> {
  final GetUserRewardsUseCase _getUserRewardsUseCase;

  GetRewardNotifier(this._getUserRewardsUseCase) : super(const RewardState());

  Future<void> fetchUserRewards() async {
    // loading state
    state = state.copyWith(
      status: GetRewardStatus.loading,
      error: null,
    );

    final result = await _getUserRewardsUseCase.call(NoParams());

    result.fold(
      (Failure failure) {
        state = state.copyWith(
          status: GetRewardStatus.error,
          error: failure.message,
        );
      },
      (RewardResponse rewards) {
        state = state.copyWith(
          status: GetRewardStatus.data,
          rewards: rewards,
          error: null,
        );
      },
    );
  }
}
