import 'package:cointiply_app/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:cointiply_app/features/wallet/data/repositories/withdrawal_option_repository_impl.dart';
import 'package:cointiply_app/features/wallet/domain/repositories/withdrawal_option_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final withdrawalOptionRepositoryProvider =
    Provider<WithdrawalOptionRepository>((ref) {
  final remote = ref.read(walletRemoteDataSourceProvider);
  return WithdrawalOptionRepositoryImpl(remote);
});
