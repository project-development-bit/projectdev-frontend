import 'package:gigafaucet/features/pirate_treasure_hunt/data/model/response/treasure_hunt_start_model.dart';

enum StartTreasureHuntNotifierStatus {
  initial,
  loading,
  success,
  error,
}

class StartTreasureHuntNotifierState {
  final StartTreasureHuntNotifierStatus status;
  final TreasureHuntStartModel? data;
  final String? error;

  const StartTreasureHuntNotifierState({
    this.status = StartTreasureHuntNotifierStatus.initial,
    this.data,
    this.error,
  });

  StartTreasureHuntNotifierState copyWith({
    StartTreasureHuntNotifierStatus? status,
    TreasureHuntStartModel? data,
    String? error,
  }) {
    return StartTreasureHuntNotifierState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  bool get isLoading => status == StartTreasureHuntNotifierStatus.loading;
  bool get isSuccess => status == StartTreasureHuntNotifierStatus.success;
  bool get isError => status == StartTreasureHuntNotifierStatus.error;
}
