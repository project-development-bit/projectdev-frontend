import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/start_treasure_hunt_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/start_treasure_hunt_notifier_state.dart';

class StartTreasureHuntNotifier
    extends StateNotifier<StartTreasureHuntNotifierState> {
  final StartTreasureHuntUseCase _useCase;

  StartTreasureHuntNotifier(this._useCase)
      : super(const StartTreasureHuntNotifierState());

  Future<void> start() async {
    state = state.copyWith(status: StartTreasureHuntNotifierStatus.loading);

    final result = await _useCase.call(NoParams());

    result.fold(
      (failure) => state = state.copyWith(
        status: StartTreasureHuntNotifierStatus.error,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        status: StartTreasureHuntNotifierStatus.success,
        data: data,
      ),
    );
  }

  void reset() {
    state = const StartTreasureHuntNotifierState();
  }
}
