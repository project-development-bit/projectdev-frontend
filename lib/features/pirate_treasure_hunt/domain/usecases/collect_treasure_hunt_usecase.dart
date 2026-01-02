import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/collect_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_collect_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/repository/treasure_hunt_repository.dart';

final collectTreasureHuntUseCaseProvider =
    Provider<CollectTreasureHuntUseCase>((ref) {
  final repo = ref.read(treasureHuntRepositoryProvider);
  return CollectTreasureHuntUseCase(repo);
});

class CollectTreasureHuntUseCase
    implements UseCase<TreasureHuntCollectModel, CollectTreasureRequestModel> {
  final TreasureHuntRepository repository;

  CollectTreasureHuntUseCase(this.repository);

  @override
  Future<Either<Failure, TreasureHuntCollectModel>> call(
      CollectTreasureRequestModel params) {
    return repository.collect(params);
  }
}
