import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/uncover_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_uncover_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/repository/treasure_hunt_repository.dart';

final uncoverTreasureUseCaseProvider = Provider<UncoverTreasureUseCase>((ref) {
  final repo = ref.read(treasureHuntRepositoryProvider);
  return UncoverTreasureUseCase(repo);
});

class UncoverTreasureUseCase
    implements UseCase<TreasureHuntUncoverModel, UncoverTreasureRequestModel> {
  final TreasureHuntRepository repository;

  UncoverTreasureUseCase(this.repository);

  @override
  Future<Either<Failure, TreasureHuntUncoverModel>> call(
    UncoverTreasureRequestModel params,
  ) {
    return repository.uncover(params);
  }
}
