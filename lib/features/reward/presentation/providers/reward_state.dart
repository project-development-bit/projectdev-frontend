import 'package:cointiply_app/features/reward/data/models/response/reward_response.dart';

class RewardState {
  final RewardResponse? rewards;
  final bool isLoading;
  final String? error;

  const RewardState({
    this.rewards,
    this.isLoading = false,
    this.error,
  });

  RewardState copyWith({
    RewardResponse? rewards,
    bool? isLoading,
    String? error,
  }) {
    return RewardState(
      rewards: rewards ?? this.rewards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
