import 'package:gigafaucet/features/referrals/data/models/refferal_banner_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/base_dio_client.dart';

class ReferralBannerRemoteService {
  final DioClient _dioClient;

  ReferralBannerRemoteService(this._dioClient);

  /// Fetches all referral banners from API
  Future<List<RefferalBannerModel>> getReferralBanners() async {
    try {
      debugPrint('🔗 BannerService: Fetching referral banners...');
      debugPrint(
          '🌐 API URL: ${_dioClient.client.options.baseUrl}/referral_banners');

      final response = await _dioClient.get('/referral_banners');

      debugPrint('✅ BannerService: Response received');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;

        // Parse JSON to BannerModel list
        final banners = (data as List<dynamic>)
            .map((e) => RefferalBannerModel.fromJson(e as Map<String, dynamic>))
            .toList();

        debugPrint(
            '✅ BannerService: Parsed ${banners.length} banners successfully');
        for (final b in banners) {
          debugPrint(
              '🖼️ Banner: ${b.image} (${b.width}x${b.height}, ${b.format})');
        }

        return banners;
      } else {
        debugPrint(
            '❌ BannerService: Invalid response status: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch referral banners',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ BannerService: Dio error: ${e.message}');
      debugPrint('❌ Error Type: ${e.type}');
      debugPrint('❌ Status Code: ${e.response?.statusCode}');
      debugPrint('❌ Response Data: ${e.response?.data}');

      if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Referral banners endpoint not found',
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
          message: e.message ?? 'Network error occurred while fetching banners',
        );
      }
    } catch (e) {
      debugPrint('❌ BannerService: Unexpected error: $e');
      throw Exception(
          'An unexpected error occurred while fetching banners: $e');
    }
  }
}
