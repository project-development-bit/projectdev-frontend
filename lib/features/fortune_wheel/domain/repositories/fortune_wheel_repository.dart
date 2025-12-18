import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/fortune_wheel_reward.dart';
import '../entities/fortune_wheel_spin_response.dart';
import '../entities/fortune_wheel_status.dart';

/// Fortune wheel repository interface
///
/// Defines the contract for fortune wheel data operations
abstract class FortuneWheelRepository {
  /// Get all fortune wheel rewards
  ///
  /// Returns a list of [FortuneWheelReward] or a [Failure]
  Future<Either<Failure, List<FortuneWheelReward>>> getFortuneWheelRewards();

  /// Spin the fortune wheel
  ///
  /// Returns the [FortuneWheelSpinResponse] with the winning reward index or a [Failure]
  Future<Either<Failure, FortuneWheelSpinResponse>> spinFortuneWheel();

  /// Get fortune wheel status
  ///
  /// Returns the [FortuneWheelStatus] with spin availability info or a [Failure]
  Future<Either<Failure, FortuneWheelStatus>> getFortuneWheelStatus();
}
