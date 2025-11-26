import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/language.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting list of languages
///
/// This use case retrieves the list of available languages
/// that users can select for their profile or application settings.
///
/// This follows the clean architecture pattern where use cases
/// coordinate business logic and interact with repositories.
class GetLanguagesUseCase implements UseCaseNoParams<List<Language>> {
  final ProfileRepository repository;

  GetLanguagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Language>>> call() async {
    return await repository.getLanguages();
  }
}
