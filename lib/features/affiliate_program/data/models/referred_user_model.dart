/// Data model for referred user
class ReferredUserModel {
  final int? id;
  final String? name;
  final bool? isVerified;
  final String? userCreatedAt;
  final int? referralId;
  final int? revenueSharePct;
  final String? referralDate;
  final int? totalEarnedFromReferee;

  const ReferredUserModel({
    this.id,
    this.name,
    this.isVerified,
    this.userCreatedAt,
    this.referralId,
    this.revenueSharePct,
    this.referralDate,
    this.totalEarnedFromReferee,
  });

  factory ReferredUserModel.fromJson(Map<String, dynamic> json) {
    return ReferredUserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      isVerified: json['isVerified'] as bool?,
      userCreatedAt: json['userCreatedAt'] as String?,
      referralId: json['referralId'] as int?,
      revenueSharePct: json['revenueSharePct'] as int?,
      referralDate: json['referralDate'] as String?,
      totalEarnedFromReferee: json['totalEarnedFromReferee'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isVerified': isVerified,
      'userCreatedAt': userCreatedAt,
      'referralId': referralId,
      'revenueSharePct': revenueSharePct,
      'referralDate': referralDate,
      'totalEarnedFromReferee': totalEarnedFromReferee,
    };
  }
}
