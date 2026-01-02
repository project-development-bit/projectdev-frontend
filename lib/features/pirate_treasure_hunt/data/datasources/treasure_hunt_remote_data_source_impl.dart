import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/collect_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/treasure_hunt_history_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/uncover_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_collect_model.dart';
// import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_history_item_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_history_model.dart';
// import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_pagination_model.dart';
// import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_reward_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_start_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_status_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_uncover_model.dart';

abstract class TreasureHuntRemoteDataSource {
  /// GET /treasure-hunt/status
  Future<TreasureHuntStatusModel> getStatus();

  /// POST /treasure-hunt/uncover
  Future<TreasureHuntUncoverModel> uncover(UncoverTreasureRequestModel request);

  /// POST /treasure-hunt/collect
  Future<TreasureHuntCollectModel> collect(CollectTreasureRequestModel request);

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
      // return TreasureHuntUncoverModel(
      //   success: true,
      //   message:
      //       'Congratulations! You uncovered 30 coins! (Base: 30, Multiplier: 1x)',
      //   status: 'TREASURE_UNCOVERED',
      //   reward: TreasureHuntRewardModel(
      //     type: 'coins',
      //     baseValue: 30,
      //     multiplier: 1,
      //     finalValue: 30,
      //     value: 30,
      //     label: '+30 Coins',
      //   ),
      //   cooldownUntil: DateTime.now().add(const Duration(minutes: 5)),
      // );
    } on DioException catch (e) {
      _logDioError('uncover', e);
      throw _mapDioException(e);
    }
  }

  // ------------------------------------------------------------
  // collect
  // ------------------------------------------------------------
  @override
  Future<TreasureHuntCollectModel> collect(
      CollectTreasureRequestModel request) async {
    try {
      debugPrint('📤 POST /treasure-hunt/claim');
      final response = await dioClient.post('/treasure-hunt/claim');
      debugPrint('📥 Collect response: ${response.data}');
      return TreasureHuntCollectModel.fromJson(response.data);
      // return TreasureHuntCollectModel(
      //   message: 'Successfully collected treasure hunt rewards',
      //   success: true,
      // );
    } on DioException catch (e) {
      _logDioError('collect', e);
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

      // return TreasureHuntHistoryModel(
      //     message: 'Success',
      //     success: true,
      //     pagination: TreasureHuntPaginationModel(
      //       currentPage: 1,
      //       limit: 1,
      //       totalPages: 1,
      //       total: 1,
      //       hasNextPage: false,
      //       hasPrevPage: false,
      //     ),
      //     items: [
      //       for (int i = 1; i < 15; i++)
      //         TreasureHuntHistoryItemModel(
      //           id: i,
      //           eventType: 'reward_granted',
      //           stepNumber: i,
      //           reward: TreasureHuntRewardModel(
      //               type: i == 7
      //                   ? "extra_spin"
      //                   : i == 8
      //                       ? "offer_boost"
      //                       : i == 9
      //                           ? "ptc_discount"
      //                           : 'coins',
      //               label: '+100 Coins',
      //               baseValue: 100,
      //               multiplier: 1,
      //               finalValue: i == 1
      //                   ? 30
      //                   : i == 2
      //                       ? 50
      //                       : i == 3
      //                           ? 300
      //                           : i == 4
      //                               ? 1000
      //                               : i == 5
      //                                   ? 5000
      //                                   : i == 6
      //                                       ? 20000
      //                                       : 100,
      //               value: 30),
      //           userLevel: i,
      //           userStatus: 'bronze',
      //           statusMultiplier: '1.0',
      //           createdAt: DateTime.now(),
      //           rewardLabel: '+100 Coins',
      //         ),
      //     ]);
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
