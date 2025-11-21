import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/reward/data/models/response/reward_response.dart';

class RewardRemoteDataSource {
  final DioClient _dio;

  RewardRemoteDataSource(this._dio);

  Future<RewardResponse> getUserRewards() async {
    final response = await _dio.get('/users/rewards');

    return RewardResponse.fromJson(response.data);
  }
}
