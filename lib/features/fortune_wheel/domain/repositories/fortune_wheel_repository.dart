import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/fortune_wheel_reward.dart';

/// Fortune wheel repository interface
///
/// Defines the contract for fortune wheel data operations
abstract class FortuneWheelRepository {
  /// Get all fortune wheel rewards
  ///
  /// Returns a list of [FortuneWheelReward] or a [Failure]
  Future<Either<Failure, List<FortuneWheelReward>>> getFortuneWheelRewards();
}
