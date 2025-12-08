import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:cointiply_app/features/wallet/data/models/request/payment_history_request.dart';
import 'package:cointiply_app/features/wallet/data/repositories/payment_history_response_model.dart';
import 'package:cointiply_app/features/wallet/domain/repositories/payment_history_respoitory.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class PaymentHistoryRespoitoryImpl implements PaymentHistoryRespoitory {
  final WalletRemoteDataSource remoteDataSource;

  PaymentHistoryRespoitoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaymentHistoryResponseModel>> getPaymentHistory(
      PaymentHistoryRequest request) async {
    try {
      return Right(await remoteDataSource.getPaymentHistory(request));
    } on DioException catch (e) {
      debugPrint(
          'DioException caught in PaymentHistoryRespoitoryImpl: ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
          message: e.message,
          statusCode: e.response?.statusCode,
          errorModel: errorModel));
    } catch (e) {
      debugPrint(
          'Unexpected exception caught in PaymentHistoryRespoitoryImpl: $e');
      return Left(
        ServerFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
