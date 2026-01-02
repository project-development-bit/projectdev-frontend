import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_uncover.dart';

enum UncoverTreasureStatus {
  initial,
  loading,
  success,
  error,
}

class UncoverTreasureState {
  final UncoverTreasureStatus status;
  final TreasureHuntUncover? data;
  final String? error;

  const UncoverTreasureState({
    this.status = UncoverTreasureStatus.initial,
    this.data,
    this.error,
  });

  UncoverTreasureState copyWith({
    UncoverTreasureStatus? status,
    TreasureHuntUncover? data,
    String? error,
  }) {
    return UncoverTreasureState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  bool get isLoading => status == UncoverTreasureStatus.loading;
  bool get isSuccess => status == UncoverTreasureStatus.success;
  bool get isError => status == UncoverTreasureStatus.error;

  String countDownUntilNow() {
    if (data == null) return '';

    final now = DateTime.now().toUtc();
    final cooldownUntil = data!.cooldownUntil;

    final difference = cooldownUntil?.difference(now);

    final days = (difference?.inDays ?? 0);
    final hours = (difference?.inHours ?? 0) % 24;
    final minutes = (difference?.inMinutes ?? 0) % 60;

    final daysStr = days > 0 ? '$days Days ' : '';
    final hoursStr = hours > 0 ? '$hours Hours ' : '';
    final minutesStr = minutes > 0 ? '$minutes Minutes' : '';

    return '$daysStr$hoursStr$minutesStr'.trim();
  }

  String get formatTreasureReward {
    final rewardType =
        data?.reward?.type == 'coins' ? 'Gold' : (data?.reward?.type ?? '');

    if (data?.reward?.type != 'coins') {
      return data?.reward?.label ?? '';
    }

    return '$rewardType Bonus x ${data?.reward?.multiplier}';
  }

  bool get isCoinTypeReward {
    return data?.reward?.type == 'coins';
  }
}
