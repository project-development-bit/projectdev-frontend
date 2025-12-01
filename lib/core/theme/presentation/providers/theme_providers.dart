import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/theme_database_source.dart';
import '../../data/datasources/theme_remote_data_source.dart';
import '../../data/datasources/theme_asset_data_source.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/usecases/get_theme_config.dart';
import './dynamic_theme_provider.dart';
import '../../../network/base_dio_client.dart';

// Data sources
final themeRemoteDataSourceProvider = Provider<ThemeRemoteDataSource>((ref) {
  return ThemeRemoteDataSourceImpl(
    dioClient: ref.watch(dioClientProvider),
  );
});

final themeDatabaseSourceProvider = Provider<ThemeDatabaseSource>((ref) {
  // Note: Database should be initialized in main()
  throw UnimplementedError(
    'ThemeDatabaseSource must be initialized. '
    'Call ProviderContainer.overrideWith() in main()',
  );
});

final themeAssetDataSourceProvider = Provider<ThemeAssetDataSource>((ref) {
  return ThemeAssetDataSourceImpl();
});

// Repository
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepositoryImpl(
    remoteDataSource: ref.watch(themeRemoteDataSourceProvider),
    databaseSource: ref.watch(themeDatabaseSourceProvider),
    assetDataSource: ref.watch(themeAssetDataSourceProvider),
  );
});

// Use cases
final getThemeConfigUseCaseProvider = Provider<GetThemeConfig>((ref) {
  return GetThemeConfig(ref.watch(themeRepositoryProvider));
});

// Dynamic theme provider
final dynamicThemeProvider =
    StateNotifierProvider<DynamicThemeNotifier, DynamicThemeState>((ref) {
  return DynamicThemeNotifier(
    getThemeConfig: ref.watch(getThemeConfigUseCaseProvider),
  );
});
