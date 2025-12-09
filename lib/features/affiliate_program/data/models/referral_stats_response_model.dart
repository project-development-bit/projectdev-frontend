/// Data model for referral stats response
class ReferralStatsResponseModel {
  final bool success;
  final String message;
  final ReferralStatsData? data;

  const ReferralStatsResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ReferralStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ReferralStatsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ReferralStatsData {
  final int? referralPercent;
  final int? referralEarningsCoins;
  final int? referralUsersCount;
  final int? pendingEarningsCoins;
  final int? activeThisWeekCount;

  const ReferralStatsData({
    this.referralPercent,
    this.referralEarningsCoins,
    this.referralUsersCount,
    this.pendingEarningsCoins,
    this.activeThisWeekCount,
  });

  factory ReferralStatsData.fromJson(Map<String, dynamic> json) {
    return ReferralStatsData(
      referralPercent: json['referral_percent'] as int?,
      referralEarningsCoins: json['referral_earnings_coins'] as int?,
      referralUsersCount: json['referral_users_count'] as int?,
      pendingEarningsCoins: json['pending_earnings_coins'] as int?,
      activeThisWeekCount: json['active_this_week_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referral_percent': referralPercent,
      'referral_earnings_coins': referralEarningsCoins,
      'referral_users_count': referralUsersCount,
      'pending_earnings_coins': pendingEarningsCoins,
      'active_this_week_count': activeThisWeekCount,
    };
  }
}
