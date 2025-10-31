import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/terms_privacy_entity.dart';
import '../../domain/repositories/terms_privacy_repository.dart';
import '../datasources/terms_privacy_remote.dart';

class TermsPrivacyRepositoryImpl implements TermsPrivacyRepository {
  final TermsPrivacyRemote _remote;

  TermsPrivacyRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, TermsPrivacyEntity>> getTermsAndPrivacy() async {
    try {
      debugPrint('🏪 TermsPrivacyRepository: Starting terms and privacy fetch...');
      
      final model = await _remote.getTermsAndPrivacy();
      final entity = model.toEntity();
      
      debugPrint('✅ TermsPrivacyRepository: Successfully converted to entity');
      debugPrint('🔗 Terms URL: ${entity.termsUrl}');
      debugPrint('🔗 Privacy URL: ${entity.privacyUrl}');
      
      return Right(entity);
    } on DioException catch (e) {
      debugPrint('❌ TermsPrivacyRepository: Dio exception: ${e.message}');
      
      String errorMessage = 'Failed to fetch terms and privacy information';
      int statusCode = 500;
      
      if (e.response?.statusCode != null) {
        statusCode = e.response!.statusCode!;
      }
      
      if (e.response?.statusCode == 404) {
        errorMessage = 'Terms and privacy service is not available';
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Unable to connect to server. Please try again later.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      
      return Left(
        ServerFailure(
          message: errorMessage,
          statusCode: statusCode,
        ),
      );
    } catch (e) {
      debugPrint('❌ TermsPrivacyRepository: Unexpected error: $e');
      return Left(
        ServerFailure(
          message: 'An unexpected error occurred while fetching terms and privacy',
          statusCode: 500,
        ),
      );
    }
  }
}