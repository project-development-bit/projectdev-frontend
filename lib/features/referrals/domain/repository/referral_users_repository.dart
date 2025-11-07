import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/referrals/data/datasources/referral_user_remote_service.dart';
import 'package:cointiply_app/features/referrals/data/repositories/referral_user_repository_impl.dart';
import 'package:cointiply_app/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';

/// Repository Provider
final referralUsersRepositoryProvider =
    Provider<ReferralUsersRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  final remote = ReferralUsersRemoteService(dioClient);
  return ReferralUsersRepositoryImpl(remote);
});

abstract class ReferralUsersRepository {
  Future<Either<Failure, List<ReferredUserEntity>>> getReferredUsers();
}
