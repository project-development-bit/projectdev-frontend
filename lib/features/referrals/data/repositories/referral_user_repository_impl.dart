import 'package:cointiply_app/features/referrals/data/datasources/referral_user_remote_service.dart';
import 'package:cointiply_app/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:cointiply_app/features/referrals/domain/repository/referral_users_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';

/// Implementation of ReferralUsersRepository
class ReferralUsersRepositoryImpl implements ReferralUsersRepository {
  final ReferralUsersRemoteService _remote;

  ReferralUsersRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<ReferredUserEntity>>> getReferredUsers() async {
    try {
      debugPrint('🏪 ReferralUsersRepository: Fetching referred users...');
      final models = await _remote.getReferredFakeUsers();

      final entities = models.map((m) => m.toEntity()).toList();

      debugPrint(
          '✅ Repository: Converted ${entities.length} users to entities');
      return Right(entities);
    } on DioException catch (e) {
      String message = 'Failed to load referred users';
      int statusCode = e.response?.statusCode ?? 500;

      if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Connection error';
      } else if (e.response?.statusCode == 404) {
        message = 'Referral users not found';
      }

      debugPrint('❌ ReferralUsersRepository: Error - $message');
      return Left(ServerFailure(message: message, statusCode: statusCode));
    } catch (e) {
      debugPrint('❌ ReferralUsersRepository: Unexpected error: $e');
      return Left(ServerFailure(
        message: 'Unexpected error occurred while loading referral users',
        statusCode: 500,
      ));
    }
  }
}
