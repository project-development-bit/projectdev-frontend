import 'package:gigafaucet/features/referrals/domain/entity/banner_entity.dart';
import 'package:gigafaucet/features/referrals/domain/repository/referral_banner_repository.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getReferralBannersUsecaseProvider =
    Provider<GetReferralBannersUsecase>((ref) {
  final repository = ref.read(referralBannerRepositoryProvider);
  return GetReferralBannersUsecase(repository);
});

class GetReferralBannersUsecase {
  final ReferralBannerRepository repository;

  GetReferralBannersUsecase(this.repository);

  Future<Either<Failure, List<ReferalBannerEntity>>> call() async {
    return await repository.getReferralBanners();
  }
}
