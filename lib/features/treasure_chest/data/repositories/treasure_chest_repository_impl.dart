import 'package:gigafaucet/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/treasure_chest_status.dart';
import '../../domain/entities/treasure_chest_open_response.dart';
import '../../domain/repositories/treasure_chest_repository.dart';
import '../datasources/remote/treasure_chest_remote.dart';

/// Provider for the treasure chest repository
final treasureChestRepositoryProvider = Provider<TreasureChestRepository>(
  (ref) => TreasureChestRepositoryImpl(
    ref.watch(treasureChestRemoteDataSourceProvider),
  ),
);

/// Implementation of [TreasureChestRepository]
///
/// Handles treasure chest operations with remote data source
class TreasureChestRepositoryImpl implements TreasureChestRepository {
  /// Remote data source for API calls
  final TreasureChestRemoteDataSource remoteDataSource;

  /// Creates an instance of [TreasureChestRepositoryImpl]
  const TreasureChestRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TreasureChestStatus>>
      getTreasureChestStatus() async {
    try {
      final statusModel = await remoteDataSource.getTreasureChestStatus();

      // Convert model to entity
      final status = statusModel.toEntity();

      return Right(status);
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
        } catch (_) {
          // If error parsing fails, continue without errorModel
        }
      }

      return Left(ServerFailure(
        message: e.message ?? 'Failed to fetch treasure chest status',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Unexpected error: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, TreasureChestOpenResponse>> openTreasureChest({
    String? deviceFingerprint,
  }) async {
    try {
      final responseModel = await remoteDataSource.openTreasureChest(
        deviceFingerprint: deviceFingerprint,
      );

      // Convert model to entity
      final response = responseModel.toEntity();

      return Right(response);
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
        } catch (_) {
          // If error parsing fails, continue without errorModel
        }
      }

      return Left(ServerFailure(
        message: e.message ?? 'Failed to open treasure chest',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Unexpected error: ${e.toString()}',
      ));
    }
  }
}
