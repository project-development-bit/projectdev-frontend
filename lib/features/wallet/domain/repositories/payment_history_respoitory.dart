import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/wallet/data/models/request/payment_history_request.dart';
import 'package:gigafaucet/features/wallet/data/repositories/payment_history_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentHistoryRespoitory {
  Future<Either<Failure, PaymentHistoryResponseModel>> getPaymentHistory(
      PaymentHistoryRequest request);
}
