import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/theme_config.dart';

/// Repository interface for theme configuration
abstract class ThemeRepository {
  /// Fetch theme configuration from server
  Future<Either<Failure, ThemeConfig>> getThemeConfig();

  /// Cache theme configuration locally
  Future<Either<Failure, void>> cacheThemeConfig(ThemeConfig config);

  /// Get cached theme configuration
  Future<Either<Failure, ThemeConfig>> getCachedThemeConfig();

  /// Clear cached theme
  Future<Either<Failure, void>> clearCache();
}
