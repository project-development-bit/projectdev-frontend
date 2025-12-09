import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/reward/data/datasource/reward_remote_datasource.dart';
import 'package:cointiply_app/features/reward/data/models/response/reward_data_model.dart';
import 'package:cointiply_app/features/reward/domain/repositories/reward_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSource remoteDataSource;

  RewardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, RewardDataModel>> getUserRewards() async {
    try {
      final RewardDataModel responseModel =
          await remoteDataSource.getUserRewards();
      return Right(responseModel);
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
          message: e.message,
          statusCode: e.response?.statusCode,
          errorModel: errorModel));
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
