import 'package:cointiply_app/features/referrals/domain/entity/banner_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ReferralBannerRepository {
  Future<Either<Failure, List<RefferalBannerEntity>>> getReferralBanners();
}
