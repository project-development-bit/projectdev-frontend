import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:cointiply_app/features/localization/data/datasource/local/localization_local_data_source.dart';
import 'package:cointiply_app/features/localization/data/datasource/remote/localization_remote_datasource_provider.dart';
import 'package:cointiply_app/features/localization/data/model/request/get_localization_request.dart';
import 'package:cointiply_app/features/localization/data/repositories/localization_repository_impl.dart';
import 'package:cointiply_app/features/localization/domain/entities/localization_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localizationRepositoryProvider = Provider<LocalizationRepository>((ref) {
  final remote = ref.read(localizationRemoteDataSourceProvider);
  final local = ref.read(localizationLocalDataSourceProvider);
  final sharedPreferences = ref.read(sharedPreferencesProviderForAppSettings);
  return LocalizationRepositoryImpl(
      remote: remote, local: local, sharedPreferences: sharedPreferences);
});

abstract class LocalizationRepository {
  Future<Either<Failure, LocalizationEntity>> getLocalization(
      GetLocalizationRequest request);
}
