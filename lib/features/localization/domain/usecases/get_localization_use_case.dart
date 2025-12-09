// domain/usecases/get_localization.dart
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/localization/domain/entities/localization_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/localization_repository.dart';

final getLocalizationUseCaseProvider = Provider<GetLocalizationUseCase>((ref) {
  final repo = ref.read(localizationRepositoryProvider);
  return GetLocalizationUseCase(repo);
});

class GetLocalizationUseCase implements UseCase<LocalizationEntity, String> {
  final LocalizationRepository repository;

  GetLocalizationUseCase(this.repository);

  @override
  Future<Either<Failure, LocalizationEntity>> call(String? locale) async {
    return await repository.getLocalization(locale);
  }
}
