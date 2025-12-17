import 'package:cointiply_app/features/faucet/data/datasources/faucet_remote_data_sourc_provider.dart';
import 'package:cointiply_app/features/faucet/data/repository/faucet_repository_impl.dart';
import 'package:cointiply_app/features/faucet/domain/repository/faucet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final faucetRepositoryProvider = Provider<FaucetRepository>((ref) {
  final remote = ref.read(faucetRemoteDataSourceProvider);
  return FaucetRepositoryImpl(remote);
});
