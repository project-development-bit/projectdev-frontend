import 'package:cointiply_app/features/faucet/domain/entity/faucet_streak_day.dart';
import 'package:equatable/equatable.dart';

class FaucetStreak extends Equatable {
  const FaucetStreak({
    required this.currentDay,
    required this.progressPercent,
    required this.dailyTarget,
    required this.earnedToday,
    required this.remaining,
    required this.days,
  });

  final int currentDay;
  final int progressPercent;
  final int dailyTarget;
  final int earnedToday;
  final int remaining;
  final List<FaucetStreakDay> days;

  /// Helper: streak completed today?
  bool get isDailyTargetReached => earnedToday >= dailyTarget;

  @override
  List<Object?> get props => [
        currentDay,
        progressPercent,
        dailyTarget,
        earnedToday,
        remaining,
        days,
      ];
}
