import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/treasure_chest_open_response.dart';
import '../repositories/treasure_chest_repository.dart';

/// Open treasure chest use case parameters
class OpenTreasureChestParams extends Equatable {
  final String? deviceFingerprint;

  const OpenTreasureChestParams({this.deviceFingerprint});

  @override
  List<Object?> get props => [deviceFingerprint];
}

/// Open treasure chest use case
///
/// Handles opening a treasure chest and receiving the reward
class OpenTreasureChestUseCase
    implements UseCase<TreasureChestOpenResponse, OpenTreasureChestParams> {
  final TreasureChestRepository repository;

  OpenTreasureChestUseCase(this.repository);

  @override
  Future<Either<Failure, TreasureChestOpenResponse>> call(
    OpenTreasureChestParams params,
  ) async {
    return await repository.openTreasureChest(
      deviceFingerprint: params.deviceFingerprint,
    );
  }
}
