import 'package:gigafaucet/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:gigafaucet/features/wallet/data/repositories/balance_repository_impl.dart';
import 'package:gigafaucet/features/wallet/domain/repositories/balance_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceRepositoryProvider = Provider<BalanceRepository>((ref) {
  final remote = ref.read(walletRemoteDataSourceProvider);
  return BalanceRepositoryImpl(remote);
});
