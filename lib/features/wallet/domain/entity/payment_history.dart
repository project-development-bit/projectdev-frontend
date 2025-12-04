import 'package:equatable/equatable.dart';

class PaymentHistory extends Equatable {
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
  final int id;
  final int userId;
  final String currency;
  final double amount;
  final double fee;
  final double netAmount;
  final String address;
  final String payoutProvider;
  final String status;
  final String? txid;
  final String? errorCode;
  final String? errorMessage;
  final DateTime requestedAt;
  final DateTime? processedAt;
  final DateTime updatedAt;

  const PaymentHistory({
    required this.id,
    required this.userId,
    required this.currency,
    required this.amount,
    required this.fee,
    required this.netAmount,
    required this.address,
    required this.payoutProvider,
    required this.status,
    this.txid,
    this.errorCode,
    this.errorMessage,
    required this.requestedAt,
    this.processedAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        currency,
        amount,
        fee,
        netAmount,
        address,
        payoutProvider,
        status,
        txid,
        errorCode,
        errorMessage,
        requestedAt,
      ];
}
