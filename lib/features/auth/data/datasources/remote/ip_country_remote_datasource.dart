import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/auth/data/models/ip_country_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ipCountryRemoteDataSourceProvider =
    Provider<IpCountryRemoteDataSource>((ref) {
  return IpCountryRemoteDataSource(
    ref.watch(dioClientProvider),
  );
});

class IpCountryRemoteDataSource {
  final DioClient dioClient;

  const IpCountryRemoteDataSource(this.dioClient);

  Future<IpCountryModel> detectCountry() async {
    try {
      debugPrint('🌍 Detecting country from IP via ipapi.co');
      final response = await dioClient.get('https://ipapi.co/json/');
      debugPrint('🌍 ipapi response status: ${response.statusCode}');
      debugPrint('🌍 ipapi response data: ${response.data}');

      if (response.data is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Invalid response format from IP API',
        );
      }

      return IpCountryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ IpCountry DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      final serverMessage = _extractServerErrorMessage(e.response?.data);

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? (e.message ?? 'Failed to detect country'),
      );
    } catch (e) {
      debugPrint('❌ Unexpected error during IP country detection: $e');
      throw Exception('Unexpected error during IP country detection: $e');
    }
  }

  String? _extractServerErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['reason'] is String) {
        return responseData['reason'] as String? ?? "";
      }
      if (responseData['error'] is String) {
        return responseData['error'] as String? ?? "";
      }
      if (responseData['message'] is String) {
        return responseData['message'] as String? ?? "";
      }
    }
    return null;
  }
}
