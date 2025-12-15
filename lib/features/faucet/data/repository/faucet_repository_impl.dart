import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/faucet/data/datasources/faucet_remote_data_source.dart';
import 'package:cointiply_app/features/faucet/data/model/actual_faucet_status_model.dart';
import 'package:cointiply_app/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:cointiply_app/features/faucet/domain/repository/faucet_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class FaucetRepositoryImpl implements FaucetRepository {
  final FaucetRemoteDataSource remoteDataSource;

  FaucetRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActualFaucetStatusModel>> getFaucetStatus() async {
    try {
      final ActualFaucetStatusModel responseModel =
          await remoteDataSource.getFaucetStatus();

      return Right(responseModel);
    } on DioException catch (e) {
      ErrorModel? errorModel;

      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }

      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.response?.statusCode,
          errorModel: errorModel,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> claimFaucet(
    ClaimFaucetRequestModel request,
  ) async {
    try {
      await remoteDataSource.claimFaucet(request);
      return const Right(unit);
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
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
