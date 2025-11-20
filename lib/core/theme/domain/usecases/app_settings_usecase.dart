import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/theme/data/repositories/app_settings_repository_impl.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/app_settings_model.dart';

final getAppSettingsUseCaseProvider = Provider<GetAppSettingsUseCase>((ref) {
  final repository = ref.watch(appSettingsRepositoryProvider);
  return GetAppSettingsUseCase(repository);
});

/// UseCase implementation
class GetAppSettingsUseCase implements UseCase<AppConfigData, bool> {
  final AppSettingsRepository repository;

  GetAppSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, AppConfigData>> call(bool forceRefresh) async {
    return repository.getAppSettings(forceRefresh: forceRefresh);
  }
}
