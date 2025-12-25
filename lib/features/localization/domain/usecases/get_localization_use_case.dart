// domain/usecases/get_localization.dart
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/localization/data/model/request/get_localization_request.dart';
import 'package:gigafaucet/features/localization/domain/entities/localization_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/localization_repository.dart';

final getLocalizationUseCaseProvider = Provider<GetLocalizationUseCase>((ref) {
  final repo = ref.read(localizationRepositoryProvider);
  return GetLocalizationUseCase(repo);
});

class GetLocalizationUseCase
    implements UseCase<LocalizationEntity, GetLocalizationRequest> {
  final LocalizationRepository repository;

  GetLocalizationUseCase(this.repository);

  @override
  Future<Either<Failure, LocalizationEntity>> call(
      GetLocalizationRequest request) async {
    return await repository.getLocalization(request);
  }
}
