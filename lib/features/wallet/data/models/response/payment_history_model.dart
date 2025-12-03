import 'package:cointiply_app/features/wallet/domain/entity/payment_history.dart';

class PaymentHistoryModel extends PaymentHistory {
  const PaymentHistoryModel({
    required super.id,
    required super.description,
    required super.status,
    required super.amount,
    required super.coins,
    required super.currency,
    required super.address,
    required super.date,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      amount: json['amount'] as String,
      coins: json['coins'] as String,
      currency: json['currency'] as String,
      address: json['address'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status,
      'amount': amount,
      'coins': coins,
      'currency': currency,
      'address': address,
      'date': date,
    };
  }
}
