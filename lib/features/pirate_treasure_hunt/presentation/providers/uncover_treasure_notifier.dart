import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/uncover_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/uncover_treasure_hunt_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/uncover_treasure_state.dart';

class UncoverTreasureNotifier extends StateNotifier<UncoverTreasureState> {
  final UncoverTreasureUseCase _useCase;

  UncoverTreasureNotifier(
    this._useCase,
  ) : super(const UncoverTreasureState());

  Future<void> uncover() async {
    state = state.copyWith(status: UncoverTreasureStatus.loading);
    final result = await _useCase.call(UncoverTreasureRequestModel());
    result.fold(
        (failure) => state = state.copyWith(
              status: UncoverTreasureStatus.error,
              error: failure.message,
            ), (data) {
      debugPrint('Testing Uncover Treasure : Success Data: $data');
      state = state.copyWith(
        status: UncoverTreasureStatus.success,
        data: data,
      );
    });
  }

  void reset() {
    state = const UncoverTreasureState();
  }
}
