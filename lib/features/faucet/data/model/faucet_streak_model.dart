import 'package:cointiply_app/features/faucet/data/model/faucet_streak_day_model.dart';
import 'package:cointiply_app/features/faucet/domain/entity/faucet_streak.dart';

class FaucetStreakModel extends FaucetStreak {
  const FaucetStreakModel({
    required super.currentDay,
    required super.progressPercent,
    required super.dailyTarget,
    required super.earnedToday,
    required super.remaining,
    required super.days,
  });

  factory FaucetStreakModel.fromJson(Map<String, dynamic> json) {
    return FaucetStreakModel(
      currentDay: json['current_day'] ?? 0,
      progressPercent: json['progress_percent'] ?? 0,
      dailyTarget: json['daily_target'] ?? 0,
      earnedToday: json['earned_today'] ?? 0,
      remaining: json['remaining'] ?? 0,
      days: (json['days'] as List? ?? [])
          .map((e) => FaucetStreakDayModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'current_day': currentDay,
        'progress_percent': progressPercent,
        'daily_target': dailyTarget,
        'earned_today': earnedToday,
        'remaining': remaining,
        'days': days.map((e) => (e as FaucetStreakDayModel).toJson()).toList(),
      };
}
