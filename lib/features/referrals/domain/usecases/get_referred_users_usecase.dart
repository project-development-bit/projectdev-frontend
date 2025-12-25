import 'package:gigafaucet/features/referrals/domain/repository/referral_users_repository.dart';
import 'package:gigafaucet/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getReferredUsersUsecaseProvider =
    Provider<GetReferredUsersUsecase>((ref) {
  final repository = ref.read(referralUsersRepositoryProvider);
  return GetReferredUsersUsecase(repository);
});

class GetReferredUsersUsecase {
  final ReferralUsersRepository repository;

  GetReferredUsersUsecase(this.repository);

  Future<Either<Failure, List<ReferredUserEntity>>> call() async {
    return await repository.getReferredUsers();
  }
}
