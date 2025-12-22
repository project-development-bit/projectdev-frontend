import 'package:cointiply_app/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/fortune_wheel_reward.dart';
import '../../domain/entities/fortune_wheel_spin_response.dart';
import '../../domain/entities/fortune_wheel_status.dart';
import '../../domain/repositories/fortune_wheel_repository.dart';
import '../datasources/remote/fortune_wheel_remote.dart';

/// Provider for the fortune wheel repository
final fortuneWheelRepositoryProvider = Provider<FortuneWheelRepository>(
  (ref) => FortuneWheelRepositoryImpl(
    ref.watch(fortuneWheelRemoteDataSourceProvider),
  ),
);

/// Implementation of [FortuneWheelRepository]
///
/// Handles fortune wheel operations with remote data source
class FortuneWheelRepositoryImpl implements FortuneWheelRepository {
  /// Remote data source for API calls
  final FortuneWheelRemoteDataSource remoteDataSource;

  /// Creates an instance of [FortuneWheelRepositoryImpl]
  const FortuneWheelRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<FortuneWheelReward>>> getFortuneWheelRewards() async {
    try {
      final rewardModels = await remoteDataSource.getFortuneWheelRewards();
      
      // Convert models to entities
      final rewards = rewardModels.map((model) => model.toEntity()).toList();
      
      return Right(rewards);
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
        message: e.message ?? 'Failed to fetch fortune wheel rewards',
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
  Future<Either<Failure, FortuneWheelSpinResponse>> spinFortuneWheel() async {
    try {
      final spinModel = await remoteDataSource.spinFortuneWheel();

      // Convert model to entity
      final spinResponse = spinModel.toEntity();

      return Right(spinResponse);
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
        message: e.message ?? 'Failed to spin fortune wheel',
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
  Future<Either<Failure, FortuneWheelStatus>> getFortuneWheelStatus() async {
    try {
      final statusModel = await remoteDataSource.getFortuneWheelStatus();

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
        message: e.message ?? 'Failed to fetch fortune wheel status',
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
