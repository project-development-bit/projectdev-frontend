import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/referrals/data/datasources/referral_banner_remote_service.dart';
import 'package:gigafaucet/features/referrals/data/repositories/referral_banner_repository_impl.dart';
import 'package:gigafaucet/features/referrals/domain/entity/banner_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';

/// ─────────────────────────────────────────────────────────────
/// REPOSITORY PROVIDER
/// ─────────────────────────────────────────────────────────────
final referralBannerRepositoryProvider =
    Provider<ReferralBannerRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  final remote = ReferralBannerRemoteService(dioClient);
  return ReferralBannerRepositoryImpl(remote);
});

abstract class ReferralBannerRepository {
  Future<Either<Failure, List<ReferalBannerEntity>>> getReferralBanners();
}
