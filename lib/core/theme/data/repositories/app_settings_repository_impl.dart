import 'package:dartz/dartz.dart';
import '../../../error/failures.dart';
import '../datasources/app_settings_local_data_source.dart';
import '../datasources/app_settings_remote_data_source.dart';
import '../models/app_settings_model.dart';

abstract class AppSettingsRepository {
  /// Get app settings from server or cache
  /// Returns [Right] with [AppConfigData] on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, AppConfigData>> getAppSettings({bool forceRefresh = false});
}

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsRemoteDataSource remoteDataSource;
  final AppSettingsLocalDataSource localDataSource;

  AppSettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AppConfigData>> getAppSettings({
    bool forceRefresh = false,
  }) async {
    try {
      // Try to get from cache first if not forcing refresh
      if (!forceRefresh) {
        final cachedSettings = await localDataSource.getCachedAppSettings();
        if (cachedSettings != null && cachedSettings.data.isNotEmpty) {
          return Right(cachedSettings.data.first.configData);
        }
      }

      // Fetch from server
      final response = await remoteDataSource.getAppSettings();
      
      if (!response.success || response.data.isEmpty) {
        return const Left(ServerFailure(message: 'Failed to fetch app settings'));
      }

      // Cache the response
      await localDataSource.cacheAppSettings(response);

      // Return the first config data
      return Right(response.data.first.configData);
    } catch (e) {
      // If network fails, try to get from cache as fallback
      try {
        final cachedSettings = await localDataSource.getCachedAppSettings();
        if (cachedSettings != null && cachedSettings.data.isNotEmpty) {
          return Right(cachedSettings.data.first.configData);
        }
      } catch (_) {
        // Ignore cache errors
      }

      return Left(ServerFailure(message: 'Failed to fetch app settings: $e'));
    }
  }
}
