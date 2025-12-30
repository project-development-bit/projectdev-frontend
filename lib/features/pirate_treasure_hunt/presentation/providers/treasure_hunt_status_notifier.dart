import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/get_treasure_hunt_status_usecase.dart';
import 'treasure_hunt_state.dart';

class TreasureHuntStatusNotifier extends StateNotifier<TreasureHuntState> {
  final GetTreasureHuntStatusUseCase _useCase;

  TreasureHuntStatusNotifier(this._useCase) : super(const TreasureHuntState());

  Future<void> fetchStatus() async {
    state = state.copyWith(status: TreasureHuntStatus.loading);

    final result = await _useCase.call(NoParams());

    result.fold(
      (failure) => state = state.copyWith(
        status: TreasureHuntStatus.error,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        status: TreasureHuntStatus.success,
        data: data,
      ),
    );
  }
}
