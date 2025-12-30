import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_status_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/repository/treasure_hunt_repository.dart';

final getTreasureHuntStatusUseCaseProvider =
    Provider<GetTreasureHuntStatusUseCase>((ref) {
  final repo = ref.read(treasureHuntRepositoryProvider);
  return GetTreasureHuntStatusUseCase(repo);
});

class GetTreasureHuntStatusUseCase
    implements UseCase<TreasureHuntStatusModel, NoParams> {
  final TreasureHuntRepository repository;

  GetTreasureHuntStatusUseCase(this.repository);

  @override
  Future<Either<Failure, TreasureHuntStatusModel>> call(NoParams params) {
    return repository.getStatus();
  }
}
