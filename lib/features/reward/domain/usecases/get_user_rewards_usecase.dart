import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/reward/data/models/response/reward_data_model.dart';
import 'package:gigafaucet/features/reward/data/repositories/reward_repository_provider.dart';
import 'package:gigafaucet/features/reward/domain/repositories/reward_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserRewardsUseCaseProvider = Provider<GetUserRewardsUseCase>((ref) {
  final repo = ref.read(rewardRepositoryProvider);
  return GetUserRewardsUseCase(repo);
});

class GetUserRewardsUseCase implements UseCase<RewardDataModel, NoParams> {
  final RewardRepository repository;

  GetUserRewardsUseCase(this.repository);

  @override
  Future<Either<Failure, RewardDataModel>> call(NoParams params) {
    return repository.getUserRewards();
  }
}
