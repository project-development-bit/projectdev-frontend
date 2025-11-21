import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/reward/response/data/models/response/reward_response.dart';
import 'package:cointiply_app/features/reward/response/data/repositories/reward_repository_provider.dart';
import 'package:cointiply_app/features/reward/response/domain/repositories/reward_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserRewardsUseCaseProvider = Provider<GetUserRewardsUseCase>((ref) {
  final repo = ref.read(rewardRepositoryProvider);
  return GetUserRewardsUseCase(repo);
});

class GetUserRewardsUseCase implements UseCase<RewardResponse, NoParams> {
  final RewardRepository repository;

  GetUserRewardsUseCase(this.repository);

  @override
  Future<Either<Failure, RewardResponse>> call(NoParams params) {
    return repository.getUserRewards();
  }
}
