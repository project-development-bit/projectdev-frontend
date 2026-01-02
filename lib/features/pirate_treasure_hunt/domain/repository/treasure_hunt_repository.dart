import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/datasources/treasure_hunt_remote_data_source_provider.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/collect_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/treasure_hunt_history_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/uncover_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_collect_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_history_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_start_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_status_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_uncover_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/repository/treasure_hunt_repository_impl.dart';

final treasureHuntRepositoryProvider = Provider<TreasureHuntRepository>(
  (ref) => TreasureHuntRepositoryImpl(
    ref.watch(treasureHuntRemoteDataSourceProvider),
  ),
);

abstract class TreasureHuntRepository {
  /// GET /treasure-hunt/status
  Future<Either<Failure, TreasureHuntStatusModel>> getStatus();

  /// POST /treasure-hunt/uncover
  Future<Either<Failure, TreasureHuntUncoverModel>> uncover(
      UncoverTreasureRequestModel request);

  /// POST /treasure-hunt/uncover
  Future<Either<Failure, TreasureHuntCollectModel>> collect(
      CollectTreasureRequestModel request);

  /// POST /treasure-hunt/start
  Future<Either<Failure, TreasureHuntStartModel>> start();

  /// GET /treasure-hunt/history (pagination)
  Future<Either<Failure, TreasureHuntHistoryModel>> getHistory(
    TreasureHuntHistoryRequestModel request,
  );
}
