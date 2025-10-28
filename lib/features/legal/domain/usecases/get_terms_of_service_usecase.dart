import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/legal_document.dart';
import '../repositories/legal_repository.dart';

/// Use case for getting terms of service
class GetTermsOfServiceUseCase implements UseCaseNoParams<LegalDocument> {
  final LegalRepository repository;

  GetTermsOfServiceUseCase(this.repository);

  @override
  Future<Either<Failure, LegalDocument>> call() async {
    return await repository.getTermsOfService();
  }
}