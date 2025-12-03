import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/wallet/data/models/response/balance_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>(
  (ref) => WalletRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);

abstract class WalletRemoteDataSource {
  Future<BalanceResponseModel> getUserBalance();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final DioClient dioClient;

  const WalletRemoteDataSourceImpl(this.dioClient);

  @override
  Future<BalanceResponseModel> getUserBalance() async {
    try {
      final response = await dioClient.get('/wallet/balances');
      return BalanceResponseModel.fromJson(response.data);
    } on DioException catch (e) {
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
