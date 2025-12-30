import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/get_treasure_hunt_status_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_status_state.dart';

class TreasureHuntStatusNotifier
    extends StateNotifier<TreasureHuntStatusState> {
  final GetTreasureHuntStatusUseCase _useCase;

  TreasureHuntStatusNotifier(this._useCase)
      : super(const TreasureHuntStatusState());

  Future<void> fetchStatus() async {
    state = state.copyWith(status: TreasureHuntStateStatus.loading);

    final result = await _useCase.call(NoParams());

    result.fold(
      (failure) => state = state.copyWith(
        status: TreasureHuntStateStatus.error,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        status: TreasureHuntStateStatus.success,
        data: data,
      ),
    );
  }
}
