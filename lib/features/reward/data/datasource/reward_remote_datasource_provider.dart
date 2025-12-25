import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/reward/data/datasource/reward_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardRemoteDataSourceProvider = Provider<RewardRemoteDataSource>(
  (ref) => RewardRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);
