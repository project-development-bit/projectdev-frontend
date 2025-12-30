import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/start_treasure_hunt_usecase.dart';
import 'treasure_hunt_state.dart';

class StartTreasureHuntNotifier extends StateNotifier<TreasureHuntState> {
  final StartTreasureHuntUseCase _useCase;

  StartTreasureHuntNotifier(this._useCase) : super(const TreasureHuntState());

  Future<void> start() async {
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

  void reset() {
    state = const TreasureHuntState();
  }
}
