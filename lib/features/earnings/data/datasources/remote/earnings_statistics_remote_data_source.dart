import 'package:cointiply_app/features/earnings/data/model/request/earnings_statistics_request.dart';
import 'package:cointiply_app/features/earnings/data/model/response/statistics_response_model.dart';
import 'package:cointiply_app/core/network/base_dio_client.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class EarningsStatisticsRemoteDataSource {
  Future<StatisticsResponseModel> getStatistics(
    EarningsStatisticsRequest request,
  );
}

class EarningsStatisticsRemoteDataSourceImpl
    implements EarningsStatisticsRemoteDataSource {
  final DioClient dioClient;

  const EarningsStatisticsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<StatisticsResponseModel> getStatistics(
    EarningsStatisticsRequest request,
  ) async {
    try {
      final params = request.toQueryParams();

      debugPrint('📤 Fetching Earnings Statistics...');
      debugPrint('📤 Endpoint: /earnings/statistics');
      debugPrint('📤 Query params: $params');

      final response = await dioClient.get(
        '/earnings/statistics',
        queryParameters: params,
      );

      debugPrint('📥 Earnings Statistics received');
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Data: ${response.data}');

      return StatisticsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('❌ Statistics DioException: ${e.message}');
      debugPrint('❌ URL: ${e.requestOptions.uri}');
      debugPrint('❌ Status: ${e.response?.statusCode}');
      debugPrint('❌ Data: ${e.response?.data}');

      final serverMsg = _extractServerErrorMessage(e.response?.data);

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMsg ?? _getFallbackMessage(e),
      );
    } catch (e) {
      debugPrint('❌ Unexpected Statistics error: $e');
      throw Exception('Unexpected Statistics error: $e');
    }
  }

  /// Extract message from API
  String? _extractServerErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }

  /// Fallback for unknown messages
  String _getFallbackMessage(DioException exception) {
    final code = exception.response?.statusCode;

    switch (code) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Statistics not found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 500:
        return 'Server Error';
      default:
        return exception.message ?? 'Failed to fetch earnings statistics';
    }
  }
}
