import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/request/collect_treasure_request_model.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/collect_treasure_hunt_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/collect_treasure_hunt_notifier_state.dart';

class CollectTreasureHuntNotifier
    extends StateNotifier<CollectTreasureHuntNotifierState> {
  final CollectTreasureHuntUseCase _useCase;

  CollectTreasureHuntNotifier(this._useCase)
      : super(const CollectTreasureHuntNotifierState());

  Future<void> collect({required String turnstileToken}) async {
    state = state.copyWith(status: CollectTreasureHuntNotifierStatus.loading);

    final result = await _useCase.call(CollectTreasureRequestModel(
      turnstileToken: turnstileToken,
    ));

    result.fold(
      (failure) => state = state.copyWith(
        status: CollectTreasureHuntNotifierStatus.error,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        status: CollectTreasureHuntNotifierStatus.success,
        data: data,
      ),
    );
  }

  void reset() {
    state = const CollectTreasureHuntNotifierState();
  }
}
