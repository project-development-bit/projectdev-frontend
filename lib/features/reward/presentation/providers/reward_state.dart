// reward_state.dart

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

  const RewardState({
    this.rewards,
    this.status = GetRewardStatus.initial,
    this.error,
  });

  RewardState copyWith({
    RewardResponse? rewards,
    GetRewardStatus? status,
    String? error,
  }) {
    return RewardState(
      rewards: rewards ?? this.rewards,
      status: status ?? this.status,
      // if error is explicitly passed, use it, otherwise keep old
      error: error ?? this.error,
    );
  }
}
