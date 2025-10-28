import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/legal_document.dart';
import '../repositories/legal_repository.dart';

/// Use case for getting privacy policy
class GetPrivacyPolicyUseCase implements UseCaseNoParams<LegalDocument> {
  final LegalRepository repository;

  GetPrivacyPolicyUseCase(this.repository);

  @override
  Future<Either<Failure, LegalDocument>> call() async {
    return await repository.getPrivacyPolicy();
  }
}