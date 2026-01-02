import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/treasure_chest_status.dart';
import '../repositories/treasure_chest_repository.dart';

/// Get treasure chest status use case
///
/// Handles fetching the current treasure chest status
class GetTreasureChestStatusUseCase
    implements UseCase<TreasureChestStatus, NoParams> {
  final TreasureChestRepository repository;

  GetTreasureChestStatusUseCase(this.repository);

  @override
  Future<Either<Failure, TreasureChestStatus>> call(NoParams params) async {
    return await repository.getTreasureChestStatus();
  }
}
