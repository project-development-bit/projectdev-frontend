import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/faucet/data/model/actual_faucet_status_model.dart';
import 'package:gigafaucet/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class FaucetRemoteDataSource {
  Future<ActualFaucetStatusModel> getFaucetStatus({bool isPublic = false});
  Future<void> claimFaucet(ClaimFaucetRequestModel request);
}

class FaucetRemoteDataSourceImpl implements FaucetRemoteDataSource {
  /// HTTP client for making network requests
  final DioClient dioClient;

  /// Creates an instance of [FaucetRemoteDataSourceImpl]
  const FaucetRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ActualFaucetStatusModel> getFaucetStatus(
      {bool isPublic = false}) async {
    try {
      debugPrint('📤 Fetching faucet status... isPublic $isPublic');
      debugPrint(
          '📤 Request URL: ${isPublic ? '/faucet/public/status' : '/faucet/status'}');
      debugPrint(
        '📤 Base URL from DioClient: ${dioClient.client.options.baseUrl}',
      );

      final response = await dioClient
          .get(isPublic ? '/faucet/public/status' : '/faucet/status');

      debugPrint('📥 Faucet status response received');
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');

      return ActualFaucetStatusModel.fromJson(
        response.data['data'] as Map<String, dynamic>? ?? {},
      );
    } on DioException catch (e) {
      debugPrint('❌ Get faucet status DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      final serverMessage = _extractServerErrorMessage(e.response?.data);

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      debugPrint('❌ Unexpected error while fetching faucet status: $e');
      throw Exception('Unexpected error while fetching faucet status: $e');
    }
  }

  @override
  Future<void> claimFaucet(ClaimFaucetRequestModel request) async {
    try {
      debugPrint('📤 Claiming faucet...');
      debugPrint('📤 Request URL: /api/faucet/claim');
      debugPrint('📤 Payload: ${request.toJson()}');

      await dioClient.post(
        '/faucet/claim',
        data: request.toJson(),
      );

      debugPrint('📥 Faucet claimed successfully');
    } on DioException catch (e) {
      debugPrint('❌ Claim faucet DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      final serverMessage = _extractServerErrorMessage(e.response?.data);
      debugPrint('❌ Extracted server message: $serverMessage');

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    }
    return;
  }

  /// Extract error message from server response data
  String? _extractServerErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Check for validation errors in the code.errors array
      if (responseData['code'] != null &&
          responseData['code'] is Map &&
          responseData['code']['errors'] != null) {
        final errors = responseData['code']['errors'] as List<dynamic>;

        // Combine all error messages with field names into one text
        final errorMessages = errors
            .map((error) {
              final msg = error['msg'] as String?;
              final path = error['path'] as String?;
              if (msg != null && path != null) {
                // Capitalize first letter of path for display
                final fieldName = path[0].toUpperCase() + path.substring(1);
                return '$fieldName: $msg';
              }
              return msg;
            })
            .where((msg) => msg != null)
            .join('. ');

        if (errorMessages.isNotEmpty) {
          return errorMessages;
        }
      }

      // Fallback to general message
      return responseData['message'] as String?;
    }
    return null;
  }

  /// Get appropriate fallback message based on status code
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
        return 'Faucet status not found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 429:
        return 'Too many requests';
      case 500:
        return 'Server error';
      default:
        return exception.message ?? 'Failed to fetch faucet status';
    }
  }
}
