import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gigafaucet/core/error/error_model.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/datasources/treasure_hunt_remote_data_source_impl.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/collect_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/treasure_hunt_history_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/uncover_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_collect_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_history_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_start_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_status_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_uncover_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/repository/treasure_hunt_repository.dart';

class TreasureHuntRepositoryImpl implements TreasureHuntRepository {
  final TreasureHuntRemoteDataSource remoteDataSource;

  const TreasureHuntRepositoryImpl(this.remoteDataSource);

  // ------------------------------------------------------------
  // STATUS
  // ------------------------------------------------------------
  @override
  Future<Either<Failure, TreasureHuntStatusModel>> getStatus() async {
    try {
      final result = await remoteDataSource.getStatus();
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ------------------------------------------------------------
  // UNCOVER
  // ------------------------------------------------------------
  @override
  Future<Either<Failure, TreasureHuntUncoverModel>> uncover(
      UncoverTreasureRequestModel request) async {
    try {
      final result = await remoteDataSource.uncover(
        request,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ------------------------------------------------------------
  // COLLECT
  // ------------------------------------------------------------
  @override
  Future<Either<Failure, TreasureHuntCollectModel>> collect(
      CollectTreasureRequestModel request) async {
    try {
      final result = await remoteDataSource.collect(
        request,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ------------------------------------------------------------
  // START
  // ------------------------------------------------------------
  @override
  Future<Either<Failure, TreasureHuntStartModel>> start() async {
    try {
      final result = await remoteDataSource.start();
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ------------------------------------------------------------
  // HISTORY
  // ------------------------------------------------------------
  @override
  Future<Either<Failure, TreasureHuntHistoryModel>> getHistory(
    TreasureHuntHistoryRequestModel request,
  ) async {
    try {
      final result = await remoteDataSource.getHistory(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ------------------------------------------------------------
  // ERROR MAPPER (same pattern as FaucetRepository)
  // ------------------------------------------------------------
  Failure _mapDioFailure(DioException e) {
    ErrorModel? errorModel;

    if (e.response?.data != null) {
      errorModel = ErrorModel.fromJson(e.response!.data);
    }

    return ServerFailure(
      message: errorModel?.message ?? e.message,
      statusCode: e.response?.statusCode,
      errorModel: errorModel,
    );
  }
}
