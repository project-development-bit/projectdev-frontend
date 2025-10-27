import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/register_request.dart';

/// Register use case
///
/// Handles user registration with email, password, name, and role
class RegisterUseCase implements UseCase<void, RegisterRequest> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterRequest params) async {
    return await repository.register(params);
  }
}
