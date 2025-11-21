import 'package:cointiply_app/features/reward/response/data/datasource/reward_remote_datasource_provider.dart';
import 'package:cointiply_app/features/reward/response/data/repositories/reward_repository_impl.dart';
import 'package:cointiply_app/features/reward/response/domain/repositories/reward_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  final remote = ref.read(rewardRemoteDataSourceProvider);
  return RewardRepositoryImpl(remote);
});
