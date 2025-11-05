import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/setup_2fa_request.dart';
import '../../data/models/setup_2fa_response.dart';
import '../repositories/auth_repository.dart';

/// Use case for setting up Two-Factor Authentication
///
/// This use case handles the business logic for initiating 2FA setup for authenticated users.
/// It calls the API endpoint that generates:
/// - A secret key for the authenticator app
/// - A QR code (base64 encoded image)
/// - An otpauth URL for manual entry
class Setup2FAUseCase implements UseCase<Setup2FAResponse, Setup2FAParams> {
  final AuthRepository repository;

  Setup2FAUseCase(this.repository);

  @override
  Future<Either<Failure, Setup2FAResponse>> call(Setup2FAParams params) async {
    return await repository.setup2FA(params.request);
  }
}

/// Parameters for the Setup2FA use case
class Setup2FAParams {
  final Setup2FARequest request;

  Setup2FAParams({required this.request});
}
