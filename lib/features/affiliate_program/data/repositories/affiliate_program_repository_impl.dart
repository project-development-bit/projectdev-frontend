import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/affiliate_program/data/datasources/affiliate_program_remote_data_source.dart';
import 'package:cointiply_app/features/affiliate_program/domain/entities/referral_link_result.dart';
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
}
