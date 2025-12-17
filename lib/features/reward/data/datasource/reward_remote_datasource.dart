import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/reward/data/models/response/reward_data_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class RewardRemoteDataSource {
  Future<RewardDataModel> getUserRewards();
}

class RewardRemoteDataSourceImpl implements RewardRemoteDataSource {
  /// HTTP client for making network requests
  final DioClient dioClient;

  /// Creates an instance of [RewardRemoteDataSourceImpl]
  const RewardRemoteDataSourceImpl(this.dioClient);

  @override
  Future<RewardDataModel> getUserRewards() async {
    try {
      debugPrint('📤 Fetching user rewards...');
      debugPrint('📤 Request URL: /users/rewards');
      debugPrint(
          '📤 Base URL from DioClient: ${dioClient.client.options.baseUrl}');

      final response = await dioClient.get('/users/rewards');

      debugPrint('📥 Rewards response received');
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');

      return RewardDataModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      debugPrint('❌ Get user rewards DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      // Extract server error message from response data
      final serverMessage = _extractServerErrorMessage(e.response?.data);

      // Create new DioException with server message or appropriate fallback
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      // Handle any other unexpected exceptions
      debugPrint('❌ Unexpected error while fetching rewards: $e');
      throw Exception('Unexpected error while fetching rewards: $e');
    }
  }

  /// Extract error message from server response data
  String? _extractServerErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Adjust key if your API uses something else like 'error', 'detail', etc.
      return responseData['message'] as String?;
    }
    return null;
  }

  /// Get appropriate fallback message based on status code or original message
  String _getFallbackMessage(DioException exception) {
    final statusCode = exception.response?.statusCode;

    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Rewards not found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 500:
        return 'Server error';
      default:
        return exception.message ?? 'Failed to fetch rewards';
    }
  }
}
