import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/faucet/data/model/actual_faucet_status_model.dart';
import 'package:gigafaucet/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:dartz/dartz.dart';

abstract class FaucetRepository {
  Future<Either<Failure, ActualFaucetStatusModel>> getFaucetStatus(
      {bool isPublic = false});
  Future<Either<Failure, Unit>> claimFaucet(
    ClaimFaucetRequestModel request,
  );
}
