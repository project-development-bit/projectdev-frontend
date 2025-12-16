import 'package:cointiply_app/features/faucet/domain/entity/daily_reset.dart';
import 'package:cointiply_app/features/faucet/domain/entity/faucet_streak.dart';
import 'package:equatable/equatable.dart';

class ActualFaucetStatus extends Equatable {
  const ActualFaucetStatus({
    required this.rewardPerClaim,
    required this.intervalHours,
    required this.nextFaucetAt,
    required this.streak,
    required this.dailyReset,
    required this.isClaimNow,
  });

  final int rewardPerClaim;
  final int intervalHours;
  final DateTime nextFaucetAt;
  final bool isClaimNow;
  final DailyReset dailyReset;
  final FaucetStreak streak;

  ActualFaucetStatus copyWith({
    int? rewardPerClaim,
    int? intervalHours,
    DateTime? nextFaucetAt,
    FaucetStreak? streak,
    DailyReset? dailyReset,
    bool? isClaimNow,
  }) {
    return ActualFaucetStatus(
      rewardPerClaim: rewardPerClaim ?? this.rewardPerClaim,
      intervalHours: intervalHours ?? this.intervalHours,
      nextFaucetAt: nextFaucetAt ?? this.nextFaucetAt,
      streak: streak ?? this.streak,
      dailyReset: dailyReset ?? this.dailyReset,
      isClaimNow: isClaimNow ?? this.isClaimNow,
    );
  }

  @override
  List<Object?> get props => [
        rewardPerClaim,
        intervalHours,
        nextFaucetAt,
        streak,
        dailyReset,
        isClaimNow,
      ];
}
