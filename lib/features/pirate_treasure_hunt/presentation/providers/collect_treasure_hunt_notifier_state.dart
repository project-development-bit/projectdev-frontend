import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_collect_model.dart';

enum CollectTreasureHuntNotifierStatus {
  initial,
  loading,
  success,
  error,
}

class CollectTreasureHuntNotifierState {
  final CollectTreasureHuntNotifierStatus status;
  final TreasureHuntCollectModel? data;
  final String? error;

  const CollectTreasureHuntNotifierState({
    this.status = CollectTreasureHuntNotifierStatus.initial,
    this.data,
    this.error,
  });

  CollectTreasureHuntNotifierState copyWith({
    CollectTreasureHuntNotifierStatus? status,
    TreasureHuntCollectModel? data,
    String? error,
  }) {
    return CollectTreasureHuntNotifierState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  bool get isLoading => status == CollectTreasureHuntNotifierStatus.loading;
  bool get isSuccess => status == CollectTreasureHuntNotifierStatus.success;
  bool get isError => status == CollectTreasureHuntNotifierStatus.error;
}
