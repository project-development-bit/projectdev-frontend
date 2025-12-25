import 'package:gigafaucet/features/legal/data/models/request/contact_us_request.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/legal_repository.dart';

/// Use case for submitting contact form
class SubmitContactFormUseCase implements UseCase<void, ContactUsRequest> {
  final LegalRepository repository;

  SubmitContactFormUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ContactUsRequest params) async {
    return await repository.submitContactForm(params);
  }
}
