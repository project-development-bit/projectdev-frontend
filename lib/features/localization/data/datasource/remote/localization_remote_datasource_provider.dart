import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/localization/data/datasource/remote/localization_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localizationRemoteDataSourceProvider =
    Provider<LocalizationRemoteDataSource>(
  (ref) => LocalizationRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);
