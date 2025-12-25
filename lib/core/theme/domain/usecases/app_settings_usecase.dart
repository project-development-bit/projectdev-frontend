import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/theme/data/repositories/app_settings_repository_impl.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/app_settings_model.dart';

final getAppSettingsUseCaseProvider =
    Provider<GetRemoteAppSettingsUseCase>((ref) {
  final repository = ref.watch(appSettingsRepositoryProvider);
  return GetRemoteAppSettingsUseCase(repository);
});

/// UseCase implementation
class GetRemoteAppSettingsUseCase
    implements UseCase<AppSettingsData, NoParams> {
  final AppSettingsRepository repository;

  GetRemoteAppSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, AppSettingsData>> call(NoParams params) async {
    return repository.getRemoteAppSettings();
  }
}

final getLocalAppSettingsUseCaseProvider =
    Provider<GetLocalAppSettingsUseCase>((ref) {
  final repository = ref.watch(appSettingsRepositoryProvider);
  return GetLocalAppSettingsUseCase(repository);
});

class GetLocalAppSettingsUseCase
    implements UseCase<AppSettingsData?, NoParams> {
  final AppSettingsRepository repository;

  GetLocalAppSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, AppSettingsData?>> call(NoParams params) async {
    return repository.cacheAppSettings();
  }
}
