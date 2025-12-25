import 'package:gigafaucet/features/wallet/domain/entity/payment_history.dart';

class PaymentHistoryModel extends PaymentHistory {
  const PaymentHistoryModel({
    required super.id,
    required super.userId,
    required super.transactionType,
    required super.currency,
    required super.amount,
    required super.fee,
    required super.address,
    super.txid,
    required super.status,
    required super.paymentProvider,
    super.errorCode,
    super.errorMessage,
    required super.createdAt,
    super.confirmedAt,
    required super.updatedAt,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      transactionType: json['transactionType'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      txid: json['txid'] as String?,
      status: json['status'] as String? ?? '',
      paymentProvider: json['paymentProvider'] as String? ?? '',
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String? ?? '')
          : DateTime.now(),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String? ?? '')
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'transactionType': transactionType,
      'currency': currency,
      'amount': amount,
      'fee': fee,
      'address': address,
      'txid': txid,
      'status': status,
      'paymentProvider': paymentProvider,
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
