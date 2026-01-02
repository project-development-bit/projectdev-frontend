import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/treasure_hunt_history_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/get_treasure_hunt_history_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_history_state.dart';

class TreasureHuntHistoryNotifier
    extends StateNotifier<TreasureHuntHistoryState> {
  final GetTreasureHuntHistoryUseCase _useCase;

  TreasureHuntHistoryNotifier(this._useCase)
      : super(const TreasureHuntHistoryState());

  Future<void> fetchHistory({
    int limit = 8,
    int page = 1,
  }) async {
    state = state.copyWith(status: TreasureHuntHistoryStatus.loading);

    final result = await _useCase.call(TreasureHuntHistoryRequestModel(
      limit: limit,
      page: page,
    ));

    result.fold(
      (failure) => state = state.copyWith(
        status: TreasureHuntHistoryStatus.error,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        status: TreasureHuntHistoryStatus.success,
        data: data,
      ),
    );
  }
}
