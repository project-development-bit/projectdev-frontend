import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/treasure_hunt_history_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/get_treasure_hunt_history_usecase.dart';
import 'treasure_hunt_state.dart';

class TreasureHuntHistoryNotifier extends StateNotifier<TreasureHuntState> {
  final GetTreasureHuntHistoryUseCase _useCase;

  TreasureHuntHistoryNotifier(this._useCase) : super(const TreasureHuntState());

  Future<void> fetchHistory(
    TreasureHuntHistoryRequestModel request,
  ) async {
    state = state.copyWith(status: TreasureHuntStatus.loading);

    final result = await _useCase.call(request);

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
