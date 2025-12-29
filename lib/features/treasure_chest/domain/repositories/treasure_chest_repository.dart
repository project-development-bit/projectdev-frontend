import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/treasure_chest_status.dart';
import '../entities/treasure_chest_open_response.dart';

/// Treasure chest repository interface
///
/// Defines the contract for treasure chest data operations
abstract class TreasureChestRepository {
  /// Get treasure chest status
  ///
  /// Returns the [TreasureChestStatus] with current status info or a [Failure]
  Future<Either<Failure, TreasureChestStatus>> getTreasureChestStatus();

  /// Open treasure chest
  ///
  /// Opens a treasure chest and returns the reward or a [Failure]
  /// [deviceFingerprint] is an optional device identifier
  Future<Either<Failure, TreasureChestOpenResponse>> openTreasureChest({
    String? deviceFingerprint,
  });
}
