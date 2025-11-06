import 'package:cointiply_app/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ReferralUsersRepository {
  Future<Either<Failure, List<ReferredUserEntity>>> getReferredUsers();
}
