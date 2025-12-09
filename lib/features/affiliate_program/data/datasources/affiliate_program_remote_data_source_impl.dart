import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/affiliate_program/data/datasources/affiliate_program_remote_data_source.dart';
import 'package:cointiply_app/features/affiliate_program/data/models/referral_link_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Implementation of affiliate program remote data source
class AffiliateProgramRemoteDataSourceImpl
    implements AffiliateProgramRemoteDataSource {
  final DioClient _dio;

  AffiliateProgramRemoteDataSourceImpl({required DioClient dioClient})
      : _dio = dioClient;

  @override
  Future<ReferralLinkResponseModel> getReferralLink() async {
    try {
      debugPrint('🔗 Getting referral link...');

      final response = await _dio.get('/users/referral-link');

      debugPrint('✅ Get referral link response: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return ReferralLinkResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        final message = response.data is Map ? response.data['message'] : null;
        throw ServerFailure(message: message ?? 'Failed to get referral link');
      }
    } on DioException catch (e) {
      debugPrint('❌ Get referral link DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      final message = e.response?.data?['message'] ?? e.message;
      throw ServerFailure(message: message ?? 'Failed to get referral link');
    } catch (e) {
      debugPrint('❌ Unexpected error getting referral link: $e');
      throw ServerFailure(message: 'Failed to get referral link');
    }
  }
}
