import 'package:cointiply_app/features/faucet/domain/entity/actual_faucet_status.dart';
import 'faucet_streak_model.dart';

class ActualFaucetStatusModel extends ActualFaucetStatus {
  const ActualFaucetStatusModel({
    required super.rewardPerClaim,
    required super.intervalHours,
    required super.nextFaucetAt,
    required super.streak,
  });

  factory ActualFaucetStatusModel.fromJson(Map<String, dynamic> json) {
    return ActualFaucetStatusModel(
      rewardPerClaim: json['reward_per_claim'] ?? 0,
      intervalHours: json['interval_hours'] ?? 0,
      nextFaucetAt: DateTime.parse(
        json['next_faucet_at'] ?? DateTime.now().toIso8601String(),
      ),
      streak: FaucetStreakModel.fromJson(
        json['streak'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'reward_per_claim': rewardPerClaim,
        'interval_hours': intervalHours,
        'next_faucet_at': nextFaucetAt.toIso8601String(),
        'streak': (streak as FaucetStreakModel).toJson(),
      };
}
