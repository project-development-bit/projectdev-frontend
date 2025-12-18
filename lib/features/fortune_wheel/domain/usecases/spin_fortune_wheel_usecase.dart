import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fortune_wheel_spin_response.dart';
import '../repositories/fortune_wheel_repository.dart';

/// Spin fortune wheel use case
///
/// Handles spinning the wheel and getting the winning reward
class SpinFortuneWheelUseCase
    implements UseCase<FortuneWheelSpinResponse, NoParams> {
  final FortuneWheelRepository repository;

  SpinFortuneWheelUseCase(this.repository);

  @override
  Future<Either<Failure, FortuneWheelSpinResponse>> call(NoParams params) async {
    return await repository.spinFortuneWheel();
  }
}
