import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/base_dio_client.dart';
import '../models/terms_privacy_model.dart';

class TermsPrivacyRemote {
  final DioClient _dioClient;

  TermsPrivacyRemote(this._dioClient);

  /// Get terms and privacy information from API
  Future<TermsPrivacyModel> getTermsAndPrivacy() async {
    try {
      debugPrint('🔗 TermsPrivacyRemote: Fetching terms and privacy...');
      debugPrint('🌐 API URL: ${_dioClient.client.options.baseUrl}/terms_and_privacy');
      
      final response = await _dioClient.get('/terms_and_privacy');
      
      debugPrint('✅ TermsPrivacyRemote: Response received');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        final model = TermsPrivacyModel.fromJson(response.data);
        
        debugPrint('✅ TermsPrivacyRemote: Model parsed successfully');
        debugPrint('🔗 Terms URL: ${model.terms.url}');
        debugPrint('🔗 Privacy URL: ${model.privacy.url}');
        debugPrint('📝 Terms Version: ${model.terms.version}');
        debugPrint('📝 Privacy Version: ${model.privacy.version}');
        
        return model;
      } else {
        debugPrint('❌ TermsPrivacyRemote: Invalid response status: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch terms and privacy information',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ TermsPrivacyRemote: Dio error: ${e.message}');
      debugPrint('❌ Error Type: ${e.type}');
      debugPrint('❌ Status Code: ${e.response?.statusCode}');
      debugPrint('❌ Response Data: ${e.response?.data}');
      
      if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Terms and privacy endpoint not found',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw DioException(
          requestOptions: e.requestOptions,
          message: 'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw DioException(
          requestOptions: e.requestOptions,
          message: 'Server response timeout. Please try again.',
        );
      } else {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: e.message ?? 'Network error occurred',
        );
      }
    } catch (e) {
      debugPrint('❌ TermsPrivacyRemote: Unexpected error: $e');
      throw Exception('An unexpected error occurred while fetching terms and privacy: $e');
    }
  }
}