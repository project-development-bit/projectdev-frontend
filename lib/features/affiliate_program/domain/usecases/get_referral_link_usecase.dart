import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/affiliate_program/domain/entities/referral_link_result.dart';
import 'package:gigafaucet/features/affiliate_program/domain/repositories/affiliate_program_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case for getting user's referral link
class GetReferralLinkUseCase implements UseCaseNoParams<ReferralLinkResult> {
  final AffiliateProgramRepository repository;

  GetReferralLinkUseCase(this.repository);

  @override
  Future<Either<Failure, ReferralLinkResult>> call() async {
    return await repository.getReferralLink();
  }
}
