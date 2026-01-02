import 'package:gigafaucet/core/config/api_endpoints.dart';
import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/treasure_chest/data/models/treasure_chest_status_model.dart';
import 'package:gigafaucet/features/treasure_chest/data/models/treasure_chest_open_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the treasure chest remote data source
final treasureChestRemoteDataSourceProvider =
    Provider<TreasureChestRemoteDataSource>(
  (ref) => TreasureChestRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);

/// Abstract interface for treasure chest remote operations
abstract class TreasureChestRemoteDataSource {
  /// Get treasure chest status
  Future<TreasureChestStatusModel> getTreasureChestStatus();

  /// Open treasure chest
  Future<TreasureChestOpenResponseModel> openTreasureChest({
    String? deviceFingerprint,
  });
}

/// Implementation of [TreasureChestRemoteDataSource] that handles HTTP requests
class TreasureChestRemoteDataSourceImpl
    implements TreasureChestRemoteDataSource {
  /// HTTP client for making network requests
  final DioClient dioClient;

  /// Creates an instance of [TreasureChestRemoteDataSourceImpl]
  const TreasureChestRemoteDataSourceImpl(this.dioClient);

  @override
  Future<TreasureChestStatusModel> getTreasureChestStatus() async {
    try {
      debugPrint('🎁 Fetching treasure chest status from API');

      final response = await dioClient.get(treasureChestStatusEndpoint);

      debugPrint('🎁 Treasure chest status response: ${response.statusCode}');

      // Check if response is successful
      if (response.statusCode == 200) {
        final data = response.data;

        // Handle the response structure with success and data fields
        if (data is Map<String, dynamic>) {
          final success = data['success'] as bool? ?? false;

          if (success) {
            final statusData = data['data'] as Map<String, dynamic>? ?? {};

            final status = TreasureChestStatusModel.fromJson(statusData);

            debugPrint('🎁 Successfully parsed treasure chest status');
            return status;
          } else {
            debugPrint('🎁 API returned success: false');
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              error: 'API returned success: false',
              type: DioExceptionType.badResponse,
            );
          }
        } else {
          debugPrint('🎁 Unexpected response format');
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Unexpected response format',
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        debugPrint('🎁 Request failed with status: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      debugPrint('🎁 DioException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('🎁 Unexpected error: $e');
      throw DioException(
        requestOptions: RequestOptions(path: treasureChestStatusEndpoint),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<TreasureChestOpenResponseModel> openTreasureChest({
    String? deviceFingerprint,
  }) async {
    try {
      debugPrint('🎁 Opening treasure chest via API');

      // Prepare request body
      final Map<String, dynamic> requestBody = {};
      if (deviceFingerprint != null) {
        requestBody['deviceFingerprint'] = deviceFingerprint;
      }

      final response = await dioClient.post(
        treasureChestOpenEndpoint,
        data: requestBody,
      );

      debugPrint('🎁 Treasure chest open response: ${response.statusCode}');

      // Check if response is successful
      if (response.statusCode == 200) {
        final data = response.data;

        // Parse the response
        if (data is Map<String, dynamic>) {
          final openResponse = TreasureChestOpenResponseModel.fromJson(data);

          debugPrint('🎁 Successfully opened treasure chest');
          debugPrint('🎁 Reward: ${openResponse.reward.label}');
          debugPrint('🎁 Chests remaining: ${openResponse.chestsRemaining.total}');
          
          return openResponse;
        } else {
          debugPrint('🎁 Unexpected response format');
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Unexpected response format',
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        debugPrint('🎁 Request failed with status: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      debugPrint('🎁 DioException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('🎁 Unexpected error: $e');
      throw DioException(
        requestOptions: RequestOptions(path: treasureChestOpenEndpoint),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }
}
