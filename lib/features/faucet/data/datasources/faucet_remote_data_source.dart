import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/faucet/data/model/actual_faucet_status_model.dart';
import 'package:cointiply_app/features/faucet/data/model/faucet_streak_day_model.dart';
import 'package:cointiply_app/features/faucet/data/model/faucet_streak_model.dart';
import 'package:cointiply_app/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:dio/dio.dart';

abstract class FaucetRemoteDataSource {
  Future<ActualFaucetStatusModel> getFaucetStatus();
  Future<void> claimFaucet(ClaimFaucetRequestModel request);
}

class FaucetRemoteDataSourceImpl implements FaucetRemoteDataSource {
  /// HTTP client for making network requests
  final DioClient dioClient;

  /// Creates an instance of [FaucetRemoteDataSourceImpl]
  const FaucetRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ActualFaucetStatusModel> getFaucetStatus() async {
//     {
//   "reward_per_claim": 14,
//   "interval_hours": 4,
//   "next_faucet_at": "2025-12-15T14:00:00Z",
//   "streak": {
//     "current_day": 2,
//     "progress_percent": 78,
//     "daily_target": 300,
//     "earned_today": 46,
//     "remaining": 254,
//     "days": [
//       { "day": 1, "reward": 12 },
//       { "day": 2, "reward": 14 },
//       { "day": 3, "reward": 17 }
//     ]
//   }
// }
    return ActualFaucetStatusModel(
      rewardPerClaim: 14,
      intervalHours: 4,
      nextFaucetAt: DateTime.parse("2025-12-15T14:00:00Z"),
      streak: FaucetStreakModel(
        currentDay: 2,
        progressPercent: 78,
        dailyTarget: 300,
        earnedToday: 46,
        remaining: 254,
        days: [
          FaucetStreakDayModel(day: 1, reward: 12),
          FaucetStreakDayModel(day: 2, reward: 14),
          FaucetStreakDayModel(day: 3, reward: 17),
        ],
      ),
    );
    // try {
    //   debugPrint('📤 Fetching faucet status...');
    //   debugPrint('📤 Request URL: /api/faucet/status');
    //   debugPrint(
    //     '📤 Base URL from DioClient: ${dioClient.client.options.baseUrl}',
    //   );

    //   final response = await dioClient.get('/api/faucet/status');

    //   debugPrint('📥 Faucet status response received');
    //   debugPrint('📥 Response status: ${response.statusCode}');
    //   debugPrint('📥 Response data: ${response.data}');

    //   return ActualFaucetStatusModel.fromJson(
    //     response.data,
    //   );
    // } on DioException catch (e) {
    //   debugPrint('❌ Get faucet status DioException: ${e.message}');
    //   debugPrint('❌ Request URL: ${e.requestOptions.uri}');
    //   debugPrint('❌ Response status: ${e.response?.statusCode}');
    //   debugPrint('❌ Response data: ${e.response?.data}');

    //   final serverMessage = _extractServerErrorMessage(e.response?.data);

    //   throw DioException(
    //     requestOptions: e.requestOptions,
    //     response: e.response,
    //     message: serverMessage ?? _getFallbackMessage(e),
    //   );
    // } catch (e) {
    //   debugPrint('❌ Unexpected error while fetching faucet status: $e');
    //   throw Exception('Unexpected error while fetching faucet status: $e');
    // }
  }

  @override
  Future<void> claimFaucet(ClaimFaucetRequestModel request) async {
    // try {
    //   debugPrint('📤 Claiming faucet...');
    //   debugPrint('📤 Request URL: /api/faucet/claim');
    //   debugPrint('📤 Payload: ${request.toJson()}');

    //   await dioClient.post(
    //     '/api/faucet/claim',
    //     data: request.toJson(),
    //   );

    //   debugPrint('📥 Faucet claimed successfully');
    // } on DioException catch (e) {
    //   debugPrint('❌ Get faucet status DioException: ${e.message}');
    //   debugPrint('❌ Request URL: ${e.requestOptions.uri}');
    //   debugPrint('❌ Response status: ${e.response?.statusCode}');
    //   debugPrint('❌ Response data: ${e.response?.data}');

    //   final serverMessage = _extractServerErrorMessage(e.response?.data);

    //   throw DioException(
    //     requestOptions: e.requestOptions,
    //     response: e.response,
    //     message: serverMessage ?? _getFallbackMessage(e),
    //   );
    // }
    return;
  }

  /// Extract error message from server response data
  String? _extractServerErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
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
