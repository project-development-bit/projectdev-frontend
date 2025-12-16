import 'package:cointiply_app/features/faucet/domain/entity/faucet_streak_day.dart';

class FaucetStreakDayModel extends FaucetStreakDay {
  const FaucetStreakDayModel({
    required super.day,
    required super.reward,
    required super.target,
  });

  factory FaucetStreakDayModel.fromJson(Map<String, dynamic> json) {
    return FaucetStreakDayModel(
      day: json['day'] ?? 0,
      reward: json['reward'] ?? 0,
      target: json['target'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'reward': reward,
        'target': target,
      };
}
