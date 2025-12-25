import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/wallet/domain/entity/withdrawal_option.dart';
import 'package:dartz/dartz.dart';

abstract class WithdrawalOptionRepository {
  Future<Either<Failure, List<WithdrawalOption>>> getWithdrawalOptions();
}
