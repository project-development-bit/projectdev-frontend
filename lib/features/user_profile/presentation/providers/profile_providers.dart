import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../config/profile_config.dart';
import '../../domain/entities/user_profile.dart';
import '../../data/datasources/profile_local_data_source.dart';
import '../../data/datasources/profile_local_data_source_impl.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/datasources/profile_remote_data_source_impl.dart';
import '../../data/datasources/profile_mock_data_source.dart';
import '../../data/datasources/profile_database_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_stats.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/upload_profile_picture.dart';
import 'profile_state_notifier.dart';

/// Provider for profile remote data source
/// 
/// Automatically switches between mock data and real API based on ProfileConfig
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  if (ProfileConfig.useMockData) {
    // 🎭 Mock mode: Using fake data for development/testing
    if (ProfileConfig.enableDebugLogging) {
      print('🎭 Profile Module: Using MOCK data source');
      print(ProfileConfig.configSummary);
    }
    return ProfileMockDataSource();
  } else {
    // 🌐 API mode: Using real backend calls
    if (ProfileConfig.enableDebugLogging) {
      print('🌐 Profile Module: Using REAL API data source');
    }
    final dio = ref.read(dioProvider);
    return ProfileRemoteDataSourceImpl(dio: dio);
  }
});

/// Provider for profile local data source
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSourceImpl();
});

/// Provider for profile database data source
final profileDatabaseDataSourceProvider =
    Provider<ProfileDatabaseDataSource>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return ProfileDatabaseDataSourceImpl(secureStorage: secureStorage);
});

/// Provider for profile repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.read(profileRemoteDataSourceProvider);
  final localDataSource = ref.read(profileLocalDataSourceProvider);
  final databaseDataSource = ref.read(profileDatabaseDataSourceProvider);
  
  return ProfileRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    databaseDataSource: databaseDataSource,
  );
});

/// Provider for get user profile use case
final getUserProfileUseCaseProvider = Provider<GetUserProfile>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetUserProfile(repository);
});

/// Provider for update user profile use case
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfile>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateUserProfile(repository);
});

/// Provider for upload profile picture use case
final uploadProfilePictureUseCaseProvider = Provider<UploadProfilePicture>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UploadProfilePicture(repository);
});

/// Provider for get profile stats use case
final getProfileStatsUseCaseProvider = Provider<GetProfileStats>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetProfileStats(repository);
});

/// Provider for profile state notifier
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final getUserProfile = ref.read(getUserProfileUseCaseProvider);
  return ProfileNotifier(getUserProfile);
});

/// Provider for current user profile (convenient access)
final currentUserProfileProvider = Provider<UserProfile?>((ref) {
  final profileState = ref.watch(profileNotifierProvider);
  return profileState.profile;
});

/// Provider for profile loading state
final profileLoadingProvider = Provider<bool>((ref) {
  final profileState = ref.watch(profileNotifierProvider);
  return profileState.isLoading;
});

/// Provider for profile error
final profileErrorProvider = Provider<String?>((ref) {
  final profileState = ref.watch(profileNotifierProvider);
  return profileState.error;
});
