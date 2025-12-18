import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/theme/data/datasources/theme_asset_data_source.dart';
import 'package:cointiply_app/core/theme/data/models/app_settings_model.dart';
import 'package:cointiply_app/core/theme/presentation/providers/theme_providers.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeAssetUsecaseProvider =
    Provider<GetAssetThemeUsecase>((ref) {
  final assetDataSource = ref.watch(themeAssetDataSourceProvider);
  return GetAssetThemeUsecase(assetDataSource: assetDataSource);
});

class GetAssetThemeUsecase extends UseCaseNoParams<AppSettingsData> {
  final ThemeAssetDataSource assetDataSource;

  GetAssetThemeUsecase({required this.assetDataSource});

  @override
  Future<Either<Failure, AppSettingsData>> call()async {
    return  Right(await assetDataSource.loadDefaultTheme());
  }
}
