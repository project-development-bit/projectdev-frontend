import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login_response.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/login_request.dart';

/// Login use case
///
/// Handles user authentication with email and password
class LoginUseCase implements UseCase<LoginResponse, LoginRequest> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginRequest params) async {
    return await repository.login(params);
  }
}
