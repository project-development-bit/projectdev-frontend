import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/reward/data/models/response/reward_data_model.dart';
import 'package:gigafaucet/features/reward/domain/usecases/get_user_rewards_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reward_state.dart';

class GetRewardNotifier extends StateNotifier<RewardState> {
  final GetUserRewardsUseCase _getUserRewardsUseCase;

  GetRewardNotifier(this._getUserRewardsUseCase) : super(const RewardState()) {
    fetchUserRewards();
  }

  Future<void> fetchUserRewards() async {
    state = state.copyWith(
      status: GetRewardStatus.loading,
      error: null,
    );

    final result = await _getUserRewardsUseCase.call(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetRewardStatus.error,
          error: failure.message,
        );
      },
      (RewardDataModel response) {
        final data = response;

        state = state.copyWith(
          status: GetRewardStatus.data,
          userLevelState: data.userlevelState,
          levels: data.levels,
          isViewAll: false,
          selectedLevel: data.userlevelState.currentStatus,
        );
      },
    );
  }

  void selectLevel(String levelId) {
    state = state.copyWith(selectedLevel: levelId);
  }
}
