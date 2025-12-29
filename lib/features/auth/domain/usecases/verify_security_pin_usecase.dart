import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gigafaucet/features/auth/domain/entities/verify_security_pin_result.dart';
import 'package:gigafaucet/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

/// Use case for setting or updating security PIN
class VerifySecurityPinUsecase
    implements UseCase<VerifySecurityPinResult, VerifySecurityPinParams> {
  const VerifySecurityPinUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, VerifySecurityPinResult>> call(
      VerifySecurityPinParams params) async {
    return await repository.verifySecurityPin(
      securityPin: params.securityPin,
    );
  }
}

/// Parameters for setting security PIN
class VerifySecurityPinParams extends Equatable {
  const VerifySecurityPinParams({
    required this.securityPin,
  });

  final int securityPin;

  @override
  List<Object> get props => [
        securityPin,
      ];
}
