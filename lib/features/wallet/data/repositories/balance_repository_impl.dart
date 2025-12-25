import 'package:gigafaucet/core/error/error_model.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:gigafaucet/features/wallet/domain/entity/balance.dart';
import 'package:gigafaucet/features/wallet/domain/repositories/balance_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../models/response/balance_response_model.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final WalletRemoteDataSource remoteDataSource;

  BalanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, BalanceResponse>> getUserBalance() async {
    try {
      final BalanceResponseModel responseModel =
          await remoteDataSource.getUserBalance();
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
