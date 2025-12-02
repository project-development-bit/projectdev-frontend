import 'package:cointiply_app/features/user_profile/domain/entities/set_security_pin_result.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for setting or updating security PIN
class SetSecurityPinUsecase
    implements UseCase<SetSecurityPinResult, SetSecurityPinParams> {
  const SetSecurityPinUsecase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, SetSecurityPinResult>> call(
      SetSecurityPinParams params) async {
    return await repository.setSecurityPin(
      securityPin: params.securityPin,
      enable: params.enable,
    );
  }
}

/// Parameters for setting security PIN
class SetSecurityPinParams extends Equatable {
  const SetSecurityPinParams({
    required this.securityPin,
    required this.enable,
  });

  final int securityPin;
  final bool enable;

  @override
  List<Object> get props => [securityPin, enable];
}
