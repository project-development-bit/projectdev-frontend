import 'package:cointiply_app/features/wallet/domain/entity/payment_history.dart';

class PaymentHistoryModel extends PaymentHistory {
  //  "id": 2,
  //           "userId": 35,
  //           "currency": "BTC",
  //           "amount": 60000,
  //           "fee": 0,
  //           "netAmount": 60000,
  //           "address": "1LMcKyPmwebfygoeZP8E9jAMS2BcgH3Yip",
  //           "payoutProvider": "manual",
  //           "status": "requested",
  //           "txid": null,
  //           "errorCode": null,
  //           "errorMessage": null,
  //           "requestedAt": "2025-12-04T09:54:56.000Z",
  //           "processedAt": null,
  //           "updatedAt": "2025-12-04T09:54:56.000Z"
  const PaymentHistoryModel({
    required super.id,
    required super.userId,
    required super.currency,
    required super.amount,
    required super.fee,
    required super.netAmount,
    required super.address,
    required super.payoutProvider,
    required super.status,
    required super.txid,
    required super.errorCode,
    required super.errorMessage,
    required super.requestedAt,
    required super.processedAt,
    required super.updatedAt,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    print('Parsing PaymentHistoryModel from JSON: $json'); // Debugging line
    return PaymentHistoryModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      currency: json['currency'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      payoutProvider: json['payoutProvider'] as String? ?? '',
      status: json['status'] as String? ?? '',
      txid: json['txid'] as String?,
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      requestedAt: DateTime.tryParse(json['requestedAt'] as String? ?? '') ??
          DateTime.now(),
      processedAt: json['processedAt'] != null
          ? DateTime.tryParse(json['processedAt'] as String)
          : null,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'currency': currency,
      'amount': amount,
      'fee': fee,
      'netAmount': netAmount,
      'address': address,
      'payoutProvider': payoutProvider,
      'status': status,
      'txid': txid,
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'requestedAt': requestedAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
