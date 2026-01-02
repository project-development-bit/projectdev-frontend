import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/datasources/treasure_hunt_remote_data_source_impl.dart';

final treasureHuntRemoteDataSourceProvider =
    Provider<TreasureHuntRemoteDataSource>(
  (ref) => TreasureHuntRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);
