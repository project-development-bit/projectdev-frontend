import 'package:gigafaucet/core/error/error_model.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/earnings/domain/entity/earnings_history_response.dart';
import 'package:gigafaucet/features/earnings/domain/repository/earnings_history_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../datasources/remote/earnings_remote_data_source.dart';
import '../model/request/earnings_history_request.dart';

class EarningsHistoryRepositoryImpl implements EarningsHistoryRepository {
  final EarningsRemoteDataSource remoteDataSource;

  const EarningsHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EarningsHistoryResponse>> getEarningsHistory(
    EarningsHistoryRequestModel request,
  ) async {
    try {
      final responseModel = await remoteDataSource.getEarningsHistory(request);

      return Right(responseModel);
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
        } catch (_) {}
      }
      return Left(
        ServerFailure(
          message: e.message ?? 'Unexpected network error',
          statusCode: e.response?.statusCode,
          errorModel: errorModel,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
