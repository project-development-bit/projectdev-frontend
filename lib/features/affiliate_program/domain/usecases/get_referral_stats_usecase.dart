import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/affiliate_program/domain/entities/referral_stats_result.dart';
import 'package:cointiply_app/features/affiliate_program/domain/repositories/affiliate_program_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case for getting referral statistics
class GetReferralStatsUseCase implements UseCaseNoParams<ReferralStatsResult> {
  final AffiliateProgramRepository repository;

  GetReferralStatsUseCase(this.repository);

  @override
  Future<Either<Failure, ReferralStatsResult>> call() async {
    return await repository.getReferralStats();
  }
}
