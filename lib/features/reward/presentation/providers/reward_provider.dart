import 'package:cointiply_app/features/reward/data/models/response/reward_response.dart';
import 'package:cointiply_app/features/reward/domain/usecases/get_user_rewards_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reward_notifier.dart';
import 'reward_state.dart';

final rewardProvider =
    StateNotifierProvider<RewardNotifier, RewardState>((ref) {
  final usecase = ref.read(getUserRewardsUseCaseProvider);
  return RewardNotifier(usecase);
});

final rewardsDataProvider = Provider<RewardResponse?>((ref) {
  return ref.watch(rewardProvider).rewards;
});

final isRewardsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(rewardProvider).isLoading;
});

final rewardsErrorProvider = Provider<String?>((ref) {
  return ref.watch(rewardProvider).error;
});
