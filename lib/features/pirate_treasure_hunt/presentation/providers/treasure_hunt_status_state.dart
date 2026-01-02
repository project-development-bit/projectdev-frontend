import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_status.dart';

enum TreasureHuntStateStatus {
  initial,
  loading,
  success,
  error,
}

class TreasureHuntStatusState {
  final TreasureHuntStateStatus status;
  final TreasureHuntStatus? data;
  final String? error;

  const TreasureHuntStatusState({
    this.status = TreasureHuntStateStatus.initial,
    this.data,
    this.error,
  });

  TreasureHuntStatusState copyWith({
    TreasureHuntStateStatus? status,
    TreasureHuntStatus? data,
    String? error,
  }) {
    return TreasureHuntStatusState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  bool get isLoading => status == TreasureHuntStateStatus.loading;
  bool get isSuccess => status == TreasureHuntStateStatus.success;
  bool get isError => status == TreasureHuntStateStatus.error;

  bool get isUncoverTreasureReady {
    if (data == null) return false;
    return data!.requiredTasks == data!.completedTasks &&
        data!.currentStep == 3;
  }

  bool get isInProgress {
    if (data == null) return false;
    return data!.status == "in_progress" || data!.currentStep < 3;
  }

  String countDownUntilNow() {
    if (data == null || data!.cooldownUntil == null) return '00:00:00';

    final now = DateTime.now().toUtc();
    final cooldownUntil = data!.cooldownUntil!;

    final difference = cooldownUntil.difference(now);

    if (difference.isNegative) return '00:00:00';

    final totalSeconds = difference.inSeconds;

    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');

    final timeStr = '$hoursStr:$minutesStr';

    return days > 0 ? '$days days $timeStr' : timeStr;
  }
}
