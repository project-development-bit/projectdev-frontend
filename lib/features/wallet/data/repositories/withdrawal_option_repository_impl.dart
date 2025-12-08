import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:cointiply_app/features/wallet/data/models/response/withdrawal_option_model.dart';
import 'package:cointiply_app/features/wallet/domain/entity/withdrawal_option.dart';
import 'package:cointiply_app/features/wallet/domain/repositories/withdrawal_option_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class WithdrawalOptionRepositoryImpl implements WithdrawalOptionRepository {
  final WalletRemoteDataSource remoteDataSource;

  WithdrawalOptionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<WithdrawalOption>>> getWithdrawalOptions() async {
    try {
      final List<WithdrawalOptionModel> responseModel =
          await remoteDataSource.getWithdrawalOptions();
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
