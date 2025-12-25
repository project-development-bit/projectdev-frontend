import 'package:gigafaucet/features/reward/data/datasource/reward_remote_datasource_provider.dart';
import 'package:gigafaucet/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:gigafaucet/features/reward/domain/repositories/reward_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  final remote = ref.read(rewardRemoteDataSourceProvider);
  return RewardRepositoryImpl(remote);
});
