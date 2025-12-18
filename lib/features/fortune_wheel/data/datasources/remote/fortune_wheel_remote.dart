import 'package:cointiply_app/core/config/api_endpoints.dart';
import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/fortune_wheel/data/models/fortune_wheel_reward_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the fortune wheel remote data source
final fortuneWheelRemoteDataSourceProvider =
    Provider<FortuneWheelRemoteDataSource>(
  (ref) => FortuneWheelRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);

/// Abstract interface for fortune wheel remote operations
abstract class FortuneWheelRemoteDataSource {
  /// Get all fortune wheel rewards
  Future<List<FortuneWheelRewardModel>> getFortuneWheelRewards();
}

/// Implementation of [FortuneWheelRemoteDataSource] that handles HTTP requests
class FortuneWheelRemoteDataSourceImpl implements FortuneWheelRemoteDataSource {
  /// HTTP client for making network requests
  final DioClient dioClient;

  /// Creates an instance of [FortuneWheelRemoteDataSourceImpl]
  const FortuneWheelRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<FortuneWheelRewardModel>> getFortuneWheelRewards() async {
    try {
      debugPrint('🎡 Fetching fortune wheel rewards from API');

      final response = await dioClient.get(fortuneWheelRewardsEndpoint);

      debugPrint('🎡 Fortune wheel rewards response: ${response.statusCode}');

      // Check if response is successful
      if (response.statusCode == 200) {
        final data = response.data;

        // Handle the response structure with success and data fields
        if (data is Map<String, dynamic>) {
          final success = data['success'] as bool? ?? false;

          if (success) {
            final dataList = data['data'] as List<dynamic>? ?? [];

            final rewards = dataList
                .map((json) =>
                    FortuneWheelRewardModel.fromJson(json as Map<String, dynamic>))
                .toList();

            debugPrint('🎡 Successfully parsed ${rewards.length} rewards');
            return rewards;
          } else {
            debugPrint('🎡 API returned success: false');
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              error: 'API returned success: false',
              type: DioExceptionType.badResponse,
            );
          }
        } else {
          debugPrint('🎡 Unexpected response format');
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Unexpected response format',
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        debugPrint('🎡 Request failed with status: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      debugPrint('🎡 DioException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('🎡 Unexpected error: $e');
      throw DioException(
        requestOptions: RequestOptions(path: fortuneWheelRewardsEndpoint),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }
}
