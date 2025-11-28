// reward_state.dart

import 'package:cointiply_app/features/reward/domain/entities/reward_level.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_response.dart';

enum GetRewardStatus {
  initial,
  loading,
  data,
  error,
}

class RewardState {
  final RewardResponse? rewards;
  final GetRewardStatus status;
  final String? error;

  final List<RewardLevel> visibleLevels;

  final bool isViewAll;

  const RewardState({
    this.rewards,
    this.status = GetRewardStatus.initial,
    this.error,
    this.visibleLevels = const [],
    this.isViewAll = false,
  });

  RewardState copyWith({
    RewardResponse? rewards,
    GetRewardStatus? status,
    String? error,
    List<RewardLevel>? visibleLevels,
    bool? isViewAll,
  }) {
    return RewardState(
      rewards: rewards ?? this.rewards,
      status: status ?? this.status,
      error: error ?? this.error,
      visibleLevels: visibleLevels ?? this.visibleLevels,
      isViewAll: isViewAll ?? this.isViewAll,
    );
  }
}
