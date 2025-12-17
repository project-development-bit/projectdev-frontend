import 'package:cointiply_app/features/localization/domain/repositories/localization_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

final clearSelectedLanguageUseCaseProvider =
    Provider<ClearSelectedLanguageUseCase>((ref) {
  final repo = ref.read(localizationRepositoryProvider);
  return ClearSelectedLanguageUseCase(repo);
});

/// Use case for clearing the selected language

class ClearSelectedLanguageUseCase implements UseCaseNoParams<void> {
  final LocalizationRepository repository;

  ClearSelectedLanguageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.clearSelectedLanguageCode();
  }
}
