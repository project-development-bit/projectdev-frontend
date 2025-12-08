import 'package:equatable/equatable.dart';

class PaymentHistory extends Equatable {
  final int id;
  final int userId;
  final String transactionType;
  final String currency;
  final double amount;
  final double fee;
  final String address;
  final String? txid;
  final String status;
  final String paymentProvider;
  final String? errorCode;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime updatedAt;

  const PaymentHistory({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.currency,
    required this.amount,
    required this.fee,
    required this.address,
    this.txid,
    required this.status,
    required this.paymentProvider,
    this.errorCode,
    this.errorMessage,
    required this.createdAt,
    this.confirmedAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        transactionType,
        currency,
        amount,
        fee,
        address,
        txid,
        status,
        paymentProvider,
        errorCode,
        errorMessage,
        createdAt,
        confirmedAt,
        updatedAt,
      ];
}
