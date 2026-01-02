import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/treasure_hunt_history_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_history_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/repository/treasure_hunt_repository.dart';

final getTreasureHuntHistoryUseCaseProvider =
    Provider<GetTreasureHuntHistoryUseCase>((ref) {
  final repo = ref.read(treasureHuntRepositoryProvider);
  return GetTreasureHuntHistoryUseCase(repo);
});

class GetTreasureHuntHistoryUseCase
    implements
        UseCase<TreasureHuntHistoryModel, TreasureHuntHistoryRequestModel> {
  final TreasureHuntRepository repository;

  GetTreasureHuntHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, TreasureHuntHistoryModel>> call(
    TreasureHuntHistoryRequestModel params,
  ) {
    return repository.getHistory(params);
  }
}
