import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fortune_wheel_reward.dart';
import '../repositories/fortune_wheel_repository.dart';

/// Get fortune wheel rewards use case
///
/// Handles fetching the list of fortune wheel rewards
class GetFortuneWheelRewardsUseCase
    implements UseCase<List<FortuneWheelReward>, NoParams> {
  final FortuneWheelRepository repository;

  GetFortuneWheelRewardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FortuneWheelReward>>> call(
      NoParams params) async {
    return await repository.getFortuneWheelRewards();
  }
}
