import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/wallet/domain/entity/payment_history.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentHistoryRespoitory {
  Future<Either<Failure, List<PaymentHistory>>> getPaymentHistory();
}
