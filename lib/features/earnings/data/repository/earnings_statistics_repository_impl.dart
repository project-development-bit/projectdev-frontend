import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/earnings_statistics_repository.dart';
import '../../domain/entity/statistics_response.dart';
import '../datasources/remote/earnings_statistics_remote_data_source.dart';
import '../model/request/earnings_statistics_request.dart';

class EarningsStatisticsRepositoryImpl implements EarningsStatisticsRepository {
  final EarningsStatisticsRemoteDataSource remoteDataSource;

  const EarningsStatisticsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, StatisticsResponse>> getStatistics(
    EarningsStatisticsRequest request,
  ) async {
    try {
      final model = await remoteDataSource.getStatistics(request);
      return Right(model);
    } on DioException catch (e) {
      ErrorModel? errorModel;

      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
        } catch (_) {}
      }

      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.response?.statusCode,
          errorModel: errorModel,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
