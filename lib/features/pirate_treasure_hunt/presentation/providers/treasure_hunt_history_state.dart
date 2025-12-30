import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_history_model.dart';

enum TreasureHuntHistoryStatus {
  initial,
  loading,
  success,
  error,
}

class TreasureHuntHistoryState {
  final TreasureHuntHistoryStatus status;
  final TreasureHuntHistoryModel? data;
  final String? error;

  const TreasureHuntHistoryState({
    this.status = TreasureHuntHistoryStatus.initial,
    this.data,
    this.error,
  });

  TreasureHuntHistoryState copyWith({
    TreasureHuntHistoryStatus? status,
    TreasureHuntHistoryModel? data,
    String? error,
  }) {
    return TreasureHuntHistoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  bool get isLoading => status == TreasureHuntHistoryStatus.loading;
  bool get isSuccess => status == TreasureHuntHistoryStatus.success;
  bool get isError => status == TreasureHuntHistoryStatus.error;
}
