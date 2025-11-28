import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting list of countries
///
/// This use case retrieves the list of available countries
/// that users can select for their profile.
///
/// This follows the clean architecture pattern where use cases
/// coordinate business logic and interact with repositories.
class GetCountriesUseCase implements UseCaseNoParams<List<Country>> {
  final ProfileRepository repository;

  GetCountriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call() async {
    return await repository.getCountries();
  }
}
