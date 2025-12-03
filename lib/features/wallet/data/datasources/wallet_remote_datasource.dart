import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/wallet/data/models/response/balance_response_model.dart';
import 'package:cointiply_app/features/wallet/data/models/response/payment_history_model.dart';
import 'package:cointiply_app/features/wallet/data/models/response/withdrawal_option_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>(
  (ref) => WalletRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);

abstract class WalletRemoteDataSource {
  Future<BalanceResponseModel> getUserBalance();
  Future<List<WithdrawalOptionModel>> getWithdrawalOptions();
  Future<List<PaymentHistoryModel>> getPaymentHistory();
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

  @override
  Future<List<WithdrawalOptionModel>> getWithdrawalOptions() async {
    try {
      final response = await dioClient.get('/withdrawals/options');
      if (response.data != null) {
        if (response.data['data'] == null) {
          throw Exception("No withdrawal options found");
        }
        final data = (response.data['data'] as List)
            .map((json) => WithdrawalOptionModel.fromJson(json))
            .toList();
        return data;
      }
      throw Exception("No withdrawal options found");
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
      throw Exception('Unexpected error while fetching withdrawal options: $e');
    }
  }

  @override
  Future<List<PaymentHistoryModel>> getPaymentHistory() async {
    try {
      // final response = await dioClient.get('/transactions');
      return [
        PaymentHistoryModel(
          id: "1",
          description: "Description1",
          status: "Completed",
          amount: "\$12.50",
          coins: "1500",
          currency: "USD",
          address: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa",
          date: "2025-01-03",
        ),
        PaymentHistoryModel(
          id: "2",
          description: "Description2",
          status: "Pending",
          amount: "\$8.00",
          coins: "900",
          currency: "USD",
          address: "3FZbgi29cpjq2GjdwV8eyHuJJnkLtktZc5",
          date: "2025-01-02",
        ),
        PaymentHistoryModel(
          id: "3",
          description: "Bonus Reward",
          status: "Completed",
          amount: "\$2.00",
          coins: "300",
          currency: "USD",
          address: "Rewards System",
          date: "2025-01-01",
        ),
        PaymentHistoryModel(
          id: "4",
          description: "Deposit",
          status: "Completed",
          amount: "\$50.00",
          coins: "6000",
          currency: "USD",
          address: "Internal Wallet",
          date: "2024-12-29",
        ),
        PaymentHistoryModel(
          id: "5",
          description: "Withdrawal",
          status: "Rejected",
          amount: "\$20.00",
          coins: "2400",
          currency: "USD",
          address: "Wallet Rejected",
          date: "2024-12-25",
        ),
      ];
      // return (response.data['data'] as List)
      //     .map((json) => PaymentHistoryModel.fromJson(json))
      //     .toList();
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
      throw Exception('Unexpected error while fetching payment history: $e');
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
