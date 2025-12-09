import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/affiliate_program/data/datasources/affiliate_program_remote_data_source.dart';
import 'package:cointiply_app/features/affiliate_program/data/models/request/referred_users_request.dart';
import 'package:cointiply_app/features/affiliate_program/domain/entities/referral_link_result.dart';
import 'package:cointiply_app/features/affiliate_program/domain/entities/referral_stats_result.dart';
import 'package:cointiply_app/features/affiliate_program/domain/entities/referred_users_result.dart';
import 'package:cointiply_app/features/affiliate_program/domain/repositories/affiliate_program_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Implementation of affiliate program repository
class AffiliateProgramRepositoryImpl implements AffiliateProgramRepository {
  final AffiliateProgramRemoteDataSource remoteDataSource;

  AffiliateProgramRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReferralLinkResult>> getReferralLink() async {
    try {
      debugPrint('🔄 Repository: Getting referral link...');
      final responseModel = await remoteDataSource.getReferralLink();

      final result = ReferralLinkResult(
        message: responseModel.message,
        referralCode: responseModel.data?.referralCode ?? '',
      );

      debugPrint('✅ Repository: Referral link retrieved successfully');
      return Right(result);
    } on ServerFailure catch (e) {
      debugPrint('❌ Repository: ServerFailure from data source - ${e.message}');
      return Left(e);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      debugPrint('❌ Repository: Response data - ${e.response?.data}');

      ErrorModel? errorModel;
      String errorMessage = 'Failed to get referral link';

      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
          errorMessage = errorModel.message;
          debugPrint('✅ Parsed ErrorModel: ${errorModel.message}');
        } catch (parseError) {
          debugPrint('⚠️ Failed to parse ErrorModel: $parseError');
          if (e.response?.data is Map) {
            errorMessage = e.response?.data?['message'] ??
                e.message ??
                'Failed to get referral link';
          } else if (e.response?.data is String) {
            errorMessage = e.response?.data as String;
          } else {
            errorMessage = e.message ?? 'Failed to get referral link';
          }
        }
      } else {
        errorMessage = e.message ?? 'Failed to get referral link';
      }

      debugPrint('❌ Final error message: $errorMessage');

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      String errorMessage = 'Failed to get referral link';
      if (e is FormatException) {
        errorMessage = 'Invalid response format from server';
      } else if (e is TypeError) {
        errorMessage = 'Data type error in server response';
      }
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, ReferredUsersResult>> getReferredUsers(
      ReferredUsersRequest request) async {
    try {
      debugPrint('🔄 Repository: Getting referred users...');
      final responseModel = await remoteDataSource.getReferredUsers(request);

      final result = ReferredUsersResult(
        message: responseModel.message,
        users: responseModel.data,
        pagination: responseModel.pagination,
      );

      debugPrint('✅ Repository: Referred users retrieved successfully');
      return Right(result);
    } on ServerFailure catch (e) {
      debugPrint('❌ Repository: ServerFailure from data source - ${e.message}');
      return Left(e);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      debugPrint('❌ Repository: Response data - ${e.response?.data}');

      ErrorModel? errorModel;
      String errorMessage = 'Failed to get referred users';

      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
          errorMessage = errorModel.message;
          debugPrint('✅ Parsed ErrorModel: ${errorModel.message}');
        } catch (parseError) {
          debugPrint('⚠️ Failed to parse ErrorModel: $parseError');
          if (e.response?.data is Map) {
            errorMessage = e.response?.data?['message'] ??
                e.message ??
                'Failed to get referred users';
          } else if (e.response?.data is String) {
            errorMessage = e.response?.data as String;
          } else {
            errorMessage = e.message ?? 'Failed to get referred users';
          }
        }
      } else {
        errorMessage = e.message ?? 'Failed to get referred users';
      }

      debugPrint('❌ Final error message: $errorMessage');

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      String errorMessage = 'Failed to get referred users';
      if (e is FormatException) {
        errorMessage = 'Invalid response format from server';
      } else if (e is TypeError) {
        errorMessage = 'Data type error in server response';
      }
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, ReferralStatsResult>> getReferralStats() async {
    try {
      debugPrint('🔄 Repository: Getting referral stats...');
      final responseModel = await remoteDataSource.getReferralStats();

      final result = ReferralStatsResult(
        message: responseModel.message,
        referralPercent: responseModel.data?.referralPercent ?? 0,
        referralEarningsCoins: responseModel.data?.referralEarningsCoins ?? 0,
        referralUsersCount: responseModel.data?.referralUsersCount ?? 0,
        pendingEarningsCoins: responseModel.data?.pendingEarningsCoins ?? 0,
        activeThisWeekCount: responseModel.data?.activeThisWeekCount ?? 0,
      );

      debugPrint('✅ Repository: Referral stats retrieved successfully');
      return Right(result);
    } on ServerFailure catch (e) {
      debugPrint('❌ Repository: ServerFailure from data source - ${e.message}');
      return Left(e);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      debugPrint('❌ Repository: Response data - ${e.response?.data}');

      ErrorModel? errorModel;
      String errorMessage = 'Failed to get referral stats';

      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
          errorMessage = errorModel.message;
          debugPrint('✅ Parsed ErrorModel: ${errorModel.message}');
        } catch (parseError) {
          debugPrint('⚠️ Failed to parse ErrorModel: $parseError');
          if (e.response?.data is Map) {
            errorMessage = e.response?.data?['message'] ??
                e.message ??
                'Failed to get referral stats';
          } else if (e.response?.data is String) {
            errorMessage = e.response?.data as String;
          } else {
            errorMessage = e.message ?? 'Failed to get referral stats';
          }
        }
      } else {
        errorMessage = e.message ?? 'Failed to get referral stats';
      }

      debugPrint('❌ Final error message: $errorMessage');

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      String errorMessage = 'Failed to get referral stats';
      if (e is FormatException) {
        errorMessage = 'Invalid response format from server';
      } else if (e is TypeError) {
        errorMessage = 'Data type error in server response';
      }
      return Left(ServerFailure(message: errorMessage));
    }
  }
}
