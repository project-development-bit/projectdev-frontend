import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:cointiply_app/features/wallet/domain/entity/payment_history.dart';
import 'package:cointiply_app/features/wallet/domain/repositories/payment_history_respoitory.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PaymentHistoryRespoitoryImpl implements PaymentHistoryRespoitory {
  final WalletRemoteDataSource remoteDataSource;

  PaymentHistoryRespoitoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PaymentHistory>>> getPaymentHistory() async {
    try {
      final List<PaymentHistory> responseModel =
          await remoteDataSource.getPaymentHistory();
      print('Repository fetched ${responseModel.length} payment history items');
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
