import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/profile_config.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/datasources/profile_remote_data_source_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/upload_profile_picture.dart';

/// Provider for profile remote data source
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  
    // 🌐 API mode: Using real backend calls
    if (ProfileConfig.enableDebugLogging) {
      debugPrint('🌐 Profile Module: Using REAL API data source');
    }
    final dio = ref.read(dioClientProvider);
  return ProfileRemoteDataSourceImpl(dioClient: dio);
});


// /// Provider for profile repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.read(profileRemoteDataSourceProvider);

  return ProfileRepositoryImpl(
    remoteDataSource: remoteDataSource,
    // localDataSource: localDataSource,
    // databaseDataSource: databaseDataSource,
  );
});

/// Provider for get profile use case
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});

/// Provider for update user profile use case
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfile>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateUserProfile(repository);
});

/// Provider for upload profile picture use case
final uploadProfilePictureUseCaseProvider =
    Provider<UploadProfilePictureUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UploadProfilePictureUsecase(repository);
});

