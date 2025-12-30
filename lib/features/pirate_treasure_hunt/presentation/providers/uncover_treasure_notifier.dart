import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/providers/turnstile_provider.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/uncover_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/uncover_treasure_hunt_usecase.dart';
import 'treasure_hunt_state.dart';

class UncoverTreasureNotifier extends StateNotifier<TreasureHuntState> {
  final UncoverTreasureUseCase _useCase;
  final Ref _ref;

  UncoverTreasureNotifier(this._useCase, this._ref)
      : super(const TreasureHuntState());

  Future<void> uncover() async {
    state = state.copyWith(status: TreasureHuntStatus.loading);

    final turnstileState = _ref.read(
      turnstileNotifierProvider(TurnstileActionEnum.treasureHunt),
    );

    if (turnstileState is! TurnstileSuccess) {
      state = state.copyWith(
        status: TreasureHuntStatus.error,
        error: 'Please complete captcha to uncover treasure',
      );
      return;
    }

    final result = await _useCase.call(UncoverTreasureRequestModel(
      turnstileToken: turnstileState.token,
    ));

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
