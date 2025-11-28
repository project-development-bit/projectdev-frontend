import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_level.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_response.dart';
import 'package:cointiply_app/features/reward/domain/usecases/get_user_rewards_usecase.dart';
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
      (RewardResponse response) {
        final data = response.data!;
        final filtered = _generateVisibleLevels(
          currentLevel: data.currentLevel,
          allLevels: data.levels,
        );

        state = state.copyWith(
          status: GetRewardStatus.data,
          rewards: response,
          visibleLevels: filtered,
          isViewAll: false,
        );
      },
    );
  }

  List<RewardLevel> _generateVisibleLevels({
    required int currentLevel,
    required List<RewardLevel> allLevels,
  }) {
    final maxIndex = allLevels.length - 1;
    final idx = allLevels.indexWhere((lv) => lv.level == currentLevel);

    if (idx == -1) return allLevels.take(3).toList();

    // Case 1: first group
    if (idx == 0 || idx == 1) {
      return allLevels.take(3).toList();
    }

    // Case 2: last group
    if (idx >= maxIndex - 1) {
      return allLevels.skip(maxIndex - 2).toList();
    }

    // Case 3: middle
    return allLevels.sublist(idx - 1, idx + 2);
  }

  /// NEW: View All
  void viewAll() {
    final allLevels = state.rewards?.data?.levels ?? [];
    state = state.copyWith(
      isViewAll: true,
      visibleLevels: allLevels,
    );
  }

  /// NEW: Collapse
  void collapse() {
    final data = state.rewards?.data;
    if (data == null) return;

    final collapsed = _generateVisibleLevels(
      currentLevel: data.currentLevel,
      allLevels: data.levels,
    );

    state = state.copyWith(
      isViewAll: false,
      visibleLevels: collapsed,
    );
  }
}
