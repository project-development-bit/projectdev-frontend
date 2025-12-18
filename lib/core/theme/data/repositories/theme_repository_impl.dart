import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/theme_config.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_database_source.dart';
import '../datasources/theme_remote_data_source.dart';
import '../models/theme_config_model.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeRemoteDataSource remoteDataSource;
  final ThemeDatabaseSource databaseSource;

  ThemeRepositoryImpl({
    required this.remoteDataSource,
    required this.databaseSource,
  });

  @override
  Future<Either<Failure, ThemeConfig>> getThemeConfig() async {
    try {
      // Check stored theme version
      final storedVersion = await databaseSource.getStoredThemeVersion();

      // Fetch theme from API
      final remoteConfig = await remoteDataSource.getThemeConfig();

      // Check if we need to update (version changed or no stored theme)
      if (storedVersion == null || storedVersion != remoteConfig.version) {
        debugPrint(
            '🔄 Theme version changed: $storedVersion → ${remoteConfig.version}');
        // Save new theme to database
        await databaseSource.saveThemeConfig(remoteConfig);
        debugPrint('✅ New theme saved to database');
      } else {
        debugPrint('✓ Theme is up to date (version: $storedVersion)');
      }

      return Right(remoteConfig);
    } on DioException catch (e) {
      debugPrint('⚠️ API fetch failed, using cached theme');
      return Left(_handleDioException(e));
    } catch (e) {
      debugPrint('⚠️ Error fetching theme: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheThemeConfig(ThemeConfig config) async {
    try {
      await databaseSource.saveThemeConfig(config as ThemeConfigModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await databaseSource.clearTheme();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        return ServerFailure(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return const ServerFailure(message: 'No internet connection');
      default:
        return ServerFailure(message: 'Network error: ${e.message}');
    }
  }

  // ComponentsConfigModel _buildDefaultComponents() {
  //   return const ComponentsConfigModel(
  //     appBar: AppBarConfigModel(
  //       elevation: 0,
  //       scrolledUnderElevation: 1,
  //     ),
  //     button: ButtonConfigModel(
  //       borderRadius: 12.0,
  //       elevation: 2.0,
  //       padding: EdgeInsetsConfigModel(horizontal: 24.0, vertical: 12.0),
  //     ),
  //     textButton: ButtonConfigModel(
  //       borderRadius: 8.0,
  //       elevation: 0.0,
  //       padding: EdgeInsetsConfigModel(horizontal: 16.0, vertical: 8.0),
  //     ),
  //     inputField: InputFieldConfigModel(
  //       borderRadius: 12.0,
  //       fillOpacity: 0.3,
  //       contentPadding: EdgeInsetsConfigModel(horizontal: 16.0, vertical: 16.0),
  //       focusedBorderWidth: 2.0,
  //     ),
  //     card: CardConfigModel(
  //       borderRadius: 16.0,
  //       elevation: 1.0,
  //       margin: 8.0,
  //     ),
  //     dialog: DialogConfigModel(
  //       borderRadius: 20.0,
  //       elevation: 8.0,
  //     ),
  //     bottomNavigation: NavigationConfigModel(
  //       elevation: 8.0,
  //       type: 'fixed',
  //     ),
  //     floatingActionButton: FABConfigModel(
  //       borderRadius: 16.0,
  //       elevation: 6.0,
  //     ),
  //     checkbox: CheckboxConfigModel(
  //       borderRadius: 4.0,
  //       borderWidth: 2.0,
  //     ),
  //   );
  // }

  // TypographyConfigModel _buildDefaultTypography() {
  //   return const TypographyConfigModel(
  //     displayLarge: TextStyleConfigModel(
  //       fontSize: 57.0,
  //       fontWeight: 400,
  //       lineHeight: 1.12,
  //       letterSpacing: -0.25,
  //     ),
  //     displayMedium: TextStyleConfigModel(
  //       fontSize: 45.0,
  //       fontWeight: 400,
  //       lineHeight: 1.16,
  //     ),
  //     displaySmall: TextStyleConfigModel(
  //       fontSize: 36.0,
  //       fontWeight: 400,
  //       lineHeight: 1.22,
  //     ),
  //     headlineLarge: TextStyleConfigModel(
  //       fontSize: 32.0,
  //       fontWeight: 400,
  //       lineHeight: 1.25,
  //     ),
  //     headlineMedium: TextStyleConfigModel(
  //       fontSize: 28.0,
  //       fontWeight: 600,
  //       lineHeight: 1.29,
  //     ),
  //     headlineSmall: TextStyleConfigModel(
  //       fontSize: 24.0,
  //       fontWeight: 600,
  //       lineHeight: 1.33,
  //     ),
  //     titleLarge: TextStyleConfigModel(
  //       fontSize: 22.0,
  //       fontWeight: 600,
  //       lineHeight: 1.27,
  //     ),
  //     titleMedium: TextStyleConfigModel(
  //       fontSize: 16.0,
  //       fontWeight: 600,
  //       lineHeight: 1.5,
  //       letterSpacing: 0.15,
  //     ),
  //     titleSmall: TextStyleConfigModel(
  //       fontSize: 14.0,
  //       fontWeight: 600,
  //       lineHeight: 1.43,
  //       letterSpacing: 0.1,
  //     ),
  //     bodyLarge: TextStyleConfigModel(
  //       fontSize: 16.0,
  //       fontWeight: 400,
  //       lineHeight: 1.5,
  //       letterSpacing: 0.5,
  //     ),
  //     bodyMedium: TextStyleConfigModel(
  //       fontSize: 14.0,
  //       fontWeight: 400,
  //       lineHeight: 1.43,
  //       letterSpacing: 0.25,
  //     ),
  //     bodySmall: TextStyleConfigModel(
  //       fontSize: 12.0,
  //       fontWeight: 400,
  //       lineHeight: 1.33,
  //       letterSpacing: 0.4,
  //     ),
  //     labelLarge: TextStyleConfigModel(
  //       fontSize: 14.0,
  //       fontWeight: 600,
  //       lineHeight: 1.43,
  //       letterSpacing: 0.1,
  //     ),
  //     labelMedium: TextStyleConfigModel(
  //       fontSize: 12.0,
  //       fontWeight: 600,
  //       lineHeight: 1.33,
  //       letterSpacing: 0.5,
  //     ),
  //     labelSmall: TextStyleConfigModel(
  //       fontSize: 11.0,
  //       fontWeight: 600,
  //       lineHeight: 1.45,
  //       letterSpacing: 0.5,
  //     ),
  //   );
  // }
}
