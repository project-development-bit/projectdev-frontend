import 'package:gigafaucet/features/reward/domain/usecases/get_user_rewards_usecase.dart';
import 'package:gigafaucet/features/reward/presentation/providers/reward_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reward_state.dart';

final getRewardNotifierProvider =
    StateNotifierProvider.autoDispose<GetRewardNotifier, RewardState>((ref) {
  final usecase = ref.read(getUserRewardsUseCaseProvider);
  return GetRewardNotifier(usecase);
});
