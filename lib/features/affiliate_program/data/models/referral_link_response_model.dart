/// Data model for referral link response
class ReferralLinkResponseModel {
  const ReferralLinkResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ReferralLinkData? data;

  factory ReferralLinkResponseModel.fromJson(Map<String, dynamic> json) {
    return ReferralLinkResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ReferralLinkData.fromJson(json['data'] as Map<String, dynamic>)
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

class ReferralLinkData {
  const ReferralLinkData({
    required this.referralCode,
  });

  final String referralCode;

  factory ReferralLinkData.fromJson(Map<String, dynamic> json) {
    return ReferralLinkData(
      referralCode: json['referralCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referralCode': referralCode,
    };
  }
}
