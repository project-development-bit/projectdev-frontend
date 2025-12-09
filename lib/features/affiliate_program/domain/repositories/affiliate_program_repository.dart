import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/affiliate_program/domain/entities/referral_link_result.dart';
import 'package:dartz/dartz.dart';

/// Repository interface for affiliate program operations
abstract class AffiliateProgramRepository {
  /// Get referral link for the current user
  Future<Either<Failure, ReferralLinkResult>> getReferralLink();
}
