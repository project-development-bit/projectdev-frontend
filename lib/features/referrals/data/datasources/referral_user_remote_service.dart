import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/base_dio_client.dart';
import '../models/referred_user.dart';

/// Remote service for fetching referred users
class ReferralUsersRemoteService {
  final DioClient _dioClient;

  ReferralUsersRemoteService(this._dioClient);

  /// Fetch referred users list
  Future<List<ReferredUser>> getReferredUsers() async {
    try {
      debugPrint('🔄 ReferralUsersRemoteService: Fetching referred users...');
      final response = await _dioClient.get('/referrals/users');

      debugPrint('📊 Status: ${response.statusCode}');
      debugPrint('📦 Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['users'] as List<dynamic>;
        final users = data.map((json) => ReferredUser.fromJson(json)).toList();

        debugPrint('✅ Parsed ${users.length} referred users');
        return users;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Invalid response from referral users API',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ ReferralUsersRemoteService: DioException - ${e.message}');
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message ?? 'Failed to fetch referred users',
      );
    } catch (e) {
      debugPrint('❌ ReferralUsersRemoteService: Unexpected error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<ReferredUser>> getReferredFakeUsers() async {
    try {
      debugPrint(
          '🧪 ReferralUsersRemoteService: Using fake data (mock API)...');
      await Future.delayed(const Duration(seconds: 1)); // simulate API delay

      final fakeData = [
        {
          'username': 'CryptoFan99',
          'date': '2025-11-03',
          'full_date': 'November 3, 2025, 10:45 AM',
        },
        {
          'username': 'AirdropMaster',
          'date': '2025-10-29',
          'full_date': 'October 29, 2025, 6:12 PM',
        },
        {
          'username': 'Satoshi200',
          'date': '2025-10-15',
          'full_date': 'October 15, 2025, 9:08 AM',
        },
        {
          'username': 'BlockchainQueen',
          'date': '2025-10-10',
          'full_date': 'October 10, 2025, 2:32 PM',
        },
        {
          'username': 'DeFiGuru',
          'date': '2025-09-28',
          'full_date': 'September 28, 2025, 8:15 PM',
        },
      ];

      final users =
          fakeData.map((json) => ReferredUser.fromJson(json)).toList();

      debugPrint('✅ Mocked ${users.length} referred users');
      return users;
    } catch (e) {
      debugPrint('❌ ReferralUsersRemoteService: Unexpected error: $e');
      throw Exception('Failed to generate mock data: $e');
    }
  }
}
