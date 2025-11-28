import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_history_request.dart';
import 'package:cointiply_app/features/earnings/data/model/response/earnings_history_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final earningsHistoryRemoteDataSourceProvider =
    Provider<EarningsHistoryRemoteDataSource>(
  (
    ref,
  ) =>
      EarningsHistoryRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);

abstract class EarningsHistoryRemoteDataSource {
  Future<EarningsHistoryResponseModel> getEarningsHistory(
    EarningsHistoryRequestModel request,
  );
}

class EarningsHistoryRemoteDataSourceImpl
    implements EarningsHistoryRemoteDataSource {
  final DioClient dioClient;

  const EarningsHistoryRemoteDataSourceImpl(this.dioClient);

  @override
  Future<EarningsHistoryResponseModel> getEarningsHistory(
    EarningsHistoryRequestModel request,
  ) async {
    try {
      final queryParams = request.toQueryParams();

      debugPrint('📤 Fetching Earnings History...');
      debugPrint('📤 Endpoint: /earnings/history');
      debugPrint('📤 Query params: $queryParams');

      final response = await dioClient.get(
        '/earnings/history',
        queryParameters: queryParams,
      );

      debugPrint('📥 Earnings History received');
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Data: ${response.data}');

      return EarningsHistoryResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('❌ Earnings History DioException: ${e.message}');
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
      debugPrint('❌ Unexpected error in Earnings History: $e');
      throw Exception('Unexpected error in Earnings History: $e');
    }
  }

  /// Extract API message
  String? _extractServerErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] as String?;
    }
    return null;
  }

  /// Fallback error messages
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
        return 'Earnings history not found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 500:
        return 'Server Error';
      default:
        return exception.message ?? 'Failed to fetch earnings history';
    }
  }
}
