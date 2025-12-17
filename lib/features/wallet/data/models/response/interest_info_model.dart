import 'package:gigafaucet/features/wallet/domain/entity/interest_info.dart';

class InterestInfoModel extends InterestInfo {
  const InterestInfoModel({
    required super.interestEnabled,
    required super.interestRate,
    required super.minimumBalanceRequired,
    required super.isEligible,
    required super.nextPayoutDate,
  });

  factory InterestInfoModel.fromJson(Map<String, dynamic> json) {
    return InterestInfoModel(
      interestEnabled: json['interestEnabled'] ?? false,
      interestRate: json['interestRate']?.toDouble() ?? 0.0,
      minimumBalanceRequired: json['minimumBalanceRequired'] ?? 0,
      isEligible: json['isEligible'] ?? false,
      nextPayoutDate: json['nextPayoutDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interestEnabled': interestEnabled,
      'interestRate': interestRate,
      'minimumBalanceRequired': minimumBalanceRequired,
      'isEligible': isEligible,
      'nextPayoutDate': nextPayoutDate,
    };
  }
}
