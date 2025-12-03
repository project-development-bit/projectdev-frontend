import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/wallet/domain/entity/balance.dart';
import 'package:dartz/dartz.dart';

abstract class BalanceRepository {
  Future<Either<Failure, BalanceResponse>> getUserBalance();
}
