import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/reward/response/data/datasource/reward_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardRemoteDataSourceProvider = Provider<RewardRemoteDataSource>((ref) {
  final dio = ref.read(dioClientProvider);
  return RewardRemoteDataSource(dio);
});
