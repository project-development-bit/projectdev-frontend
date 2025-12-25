import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/wallet/domain/entity/balance.dart';
import 'package:dartz/dartz.dart';

abstract class BalanceRepository {
  Future<Either<Failure, BalanceResponse>> getUserBalance();
}
