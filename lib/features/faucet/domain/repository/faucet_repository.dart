import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/faucet/data/model/actual_faucet_status_model.dart';
import 'package:cointiply_app/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:dartz/dartz.dart';

abstract class FaucetRepository {
  Future<Either<Failure, ActualFaucetStatusModel>> getFaucetStatus();
  Future<Either<Failure, Unit>> claimFaucet(
    ClaimFaucetRequestModel request,
  );
}
