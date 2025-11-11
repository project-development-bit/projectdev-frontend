import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/contact_submission.dart';
import '../repositories/legal_repository.dart';

/// Parameters for submitting contact form
class SubmitContactFormParams {
  final ContactSubmission submission;

  SubmitContactFormParams({required this.submission});
}

/// Use case for submitting contact form
class SubmitContactFormUseCase
    implements UseCase<void, SubmitContactFormParams> {
  final LegalRepository repository;

  SubmitContactFormUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitContactFormParams params) async {
    return await repository.submitContactForm(params.submission);
  }
}
