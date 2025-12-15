import 'package:cointiply_app/features/faucet/domain/entity/faucet_streak.dart';
import 'package:equatable/equatable.dart';

class ActualFaucetStatus extends Equatable {
  const ActualFaucetStatus({
    required this.rewardPerClaim,
    required this.intervalHours,
    required this.nextFaucetAt,
    required this.streak,
  });

  final int rewardPerClaim;
  final int intervalHours;
  final DateTime nextFaucetAt;
  final FaucetStreak streak;

  /// Helper: can user claim now?
  bool get canClaim => DateTime.now().isAfter(nextFaucetAt);

  /// Helper: remaining time until next claim
  Duration get timeUntilNextClaim => nextFaucetAt.difference(DateTime.now());

  ActualFaucetStatus copyWith({
    int? rewardPerClaim,
    int? intervalHours,
    DateTime? nextFaucetAt,
    FaucetStreak? streak,
  }) {
    return ActualFaucetStatus(
      rewardPerClaim: rewardPerClaim ?? this.rewardPerClaim,
      intervalHours: intervalHours ?? this.intervalHours,
      nextFaucetAt: nextFaucetAt ?? this.nextFaucetAt,
      streak: streak ?? this.streak,
    );
  }

  @override
  List<Object?> get props => [
        rewardPerClaim,
        intervalHours,
        nextFaucetAt,
        streak,
      ];
}
