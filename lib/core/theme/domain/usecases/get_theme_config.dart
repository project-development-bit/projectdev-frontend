import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/theme_config.dart';
import '../repositories/theme_repository.dart';

/// Use case to get theme configuration
class GetThemeConfig implements UseCase<ThemeConfig, NoParams> {
  final ThemeRepository repository;

  GetThemeConfig(this.repository);

  @override
  Future<Either<Failure, ThemeConfig>> call(NoParams params) async {
    // Try to get from server first
    final serverResult = await repository.getThemeConfig();

    return serverResult.fold(
      (failure) async {
        // If server fails, try to get cached theme
        final cachedResult = await repository.getCachedThemeConfig();
        return cachedResult;
      },
      (config) async {
        // Cache the fetched config
        await repository.cacheThemeConfig(config);
        return Right(config);
      },
    );
  }
}
