import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/treasure_hunt_history_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/uncover_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_history_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_start_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_status_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_uncover_model.dart';

abstract class TreasureHuntRemoteDataSource {
  /// GET /treasure-hunt/status
  Future<TreasureHuntStatusModel> getStatus();

  /// POST /treasure-hunt/uncover
  Future<TreasureHuntUncoverModel> uncover(UncoverTreasureRequestModel request);

  /// POST /treasure-hunt/start
  Future<TreasureHuntStartModel> start();

  /// GET /treasure-hunt/history
  Future<TreasureHuntHistoryModel> getHistory(
    TreasureHuntHistoryRequestModel request,
  );
}

class TreasureHuntRemoteDataSourceImpl implements TreasureHuntRemoteDataSource {
  final DioClient dioClient;

  const TreasureHuntRemoteDataSourceImpl(this.dioClient);

  // ------------------------------------------------------------
  // STATUS
  // ------------------------------------------------------------
  @override
  Future<TreasureHuntStatusModel> getStatus() async {
    try {
      debugPrint('📤 GET /treasure-hunt/status');

      final response = await dioClient.get('/treasure-hunt/status');

      debugPrint('📥 Status response: ${response.data}');

      return TreasureHuntStatusModel.fromJson(
        response.data['data'] ?? {},
      );
    } on DioException catch (e) {
      _logDioError('getStatus', e);
      throw _mapDioException(e);
    }
  }

  // ------------------------------------------------------------
  // UNCOVER
  // ------------------------------------------------------------
  @override
  Future<TreasureHuntUncoverModel> uncover(
      UncoverTreasureRequestModel request) async {
    try {
      debugPrint('📤 POST /treasure-hunt/uncover');
      final response = await dioClient.post('/treasure-hunt/uncover');
      debugPrint('📥 Uncover response: ${response.data}');
      return TreasureHuntUncoverModel.fromJson(response.data);
    } on DioException catch (e) {
      _logDioError('uncover', e);
      throw _mapDioException(e);
    }
  }

  // ------------------------------------------------------------
  // START
  // ------------------------------------------------------------
  @override
  Future<TreasureHuntStartModel> start() async {
    try {
      debugPrint('📤 POST /treasure-hunt/start');

      final response = await dioClient.post('/treasure-hunt/start');

      debugPrint('📥 Start response: ${response.data}');

      return TreasureHuntStartModel.fromJson(
        response.data['data'] ?? {},
      );
    } on DioException catch (e) {
      _logDioError('start', e);
      throw _mapDioException(e);
    }
  }

  // ------------------------------------------------------------
  // HISTORY (with pagination)
  // ------------------------------------------------------------
  @override
  Future<TreasureHuntHistoryModel> getHistory(
    TreasureHuntHistoryRequestModel request,
  ) async {
    try {
      debugPrint('📤 GET /treasure-hunt/history');
      debugPrint('📤 Params: ${request.toJson()}');

      final response = await dioClient.get(
        '/treasure-hunt/history',
        queryParameters: request.toJson(),
      );

      debugPrint('📥 History response: ${response.data}');

      return TreasureHuntHistoryModel.fromJson(response.data);
    } on DioException catch (e) {
      _logDioError('getHistory', e);
      throw _mapDioException(e);
    }
  }

  // ------------------------------------------------------------
  // ERROR HANDLING
  // ------------------------------------------------------------

  void _logDioError(String method, DioException e) {
    debugPrint('❌ TreasureHunt $method DioException');
    debugPrint('❌ URL: ${e.requestOptions.uri}');
    debugPrint('❌ Status: ${e.response?.statusCode}');
    debugPrint('❌ Data: ${e.response?.data}');
  }

  DioException _mapDioException(DioException e) {
    final statusCode = e.response?.statusCode;

    String message;

    if (e.response?.data is Map<String, dynamic>) {
      message = e.response?.data['message'] ??
          e.message ??
          'Treasure Hunt request failed';
    } else {
      message = e.message ?? 'Treasure Hunt request failed';
    }

    switch (statusCode) {
      case 401:
        message = 'Unauthorized';
        break;
      case 403:
        message = 'Forbidden';
        break;
      case 404:
        message = 'Treasure Hunt not found';
        break;
      case 409:
        message = 'Treasure Hunt conflict';
        break;
      case 429:
        message = 'Too many requests';
        break;
      case 500:
        message = 'Server error';
        break;
    }

    return DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      message: message,
    );
  }
}
