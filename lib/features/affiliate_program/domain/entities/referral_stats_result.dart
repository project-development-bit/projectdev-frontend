/// Domain entity for referral stats result
class ReferralStatsResult {
  final String message;
  final int referralPercent;
  final int referralEarningsCoins;
  final int referralUsersCount;
  final int pendingEarningsCoins;
  final int activeThisWeekCount;

  const ReferralStatsResult({
    required this.message,
    required this.referralPercent,
    required this.referralEarningsCoins,
    required this.referralUsersCount,
    required this.pendingEarningsCoins,
    required this.activeThisWeekCount,
  });
}
