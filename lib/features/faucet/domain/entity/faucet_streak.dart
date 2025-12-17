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
    required this.maxDays,
  });

  //   "current_day": 1,
  // "max_days": 30,
  // "progress_percent": 4,
  // "daily_target": 300,
  // "earned_today": 12,
  // "remaining": 288,

  final int currentDay;
  final int progressPercent;
  final int dailyTarget;
  final int earnedToday;
  final int remaining;
  final List<FaucetStreakDay> days;
  final int maxDays;

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
        maxDays,
      ];
}
