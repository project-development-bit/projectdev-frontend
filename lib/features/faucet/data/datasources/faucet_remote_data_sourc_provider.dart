import 'package:gigafaucet/features/faucet/data/datasources/faucet_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/network/base_dio_client.dart';

final faucetRemoteDataSourceProvider = Provider<FaucetRemoteDataSource>(
  (ref) => FaucetRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);
