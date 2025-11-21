import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/base_dio_client.dart';
import '../data/datasources/profile_remote_data_source.dart';
import '../data/datasources/profile_remote_data_source_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_profile_usecase.dart';

/// Provider for profile remote data source
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSourceImpl(
    dioClient: ref.watch(dioClientProvider),
  ),
);

/// Provider for profile repository
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
  ),
);

/// Provider for get profile use case
final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => GetProfileUseCase(
    ref.watch(profileRepositoryProvider),
  ),
);
