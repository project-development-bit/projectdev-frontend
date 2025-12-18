import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fortune_wheel_status.dart';
import '../repositories/fortune_wheel_repository.dart';

/// Get fortune wheel status use case
///
/// Handles fetching the current spin status
class GetFortuneWheelStatusUseCase
    implements UseCase<FortuneWheelStatus, NoParams> {
  final FortuneWheelRepository repository;

  GetFortuneWheelStatusUseCase(this.repository);

  @override
  Future<Either<Failure, FortuneWheelStatus>> call(NoParams params) async {
    return await repository.getFortuneWheelStatus();
  }
}
