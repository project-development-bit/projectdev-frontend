import 'package:equatable/equatable.dart';

class PaymentHistory extends Equatable {
  final String id;
  final String description;
  final String status;
  final String amount; // e.g. "$10.00" – String (formatted)
  final String coins; // e.g. "1500 coins"
  final String currency; // e.g. "USD" or "$"
  final String address;
  final String date; // formatted date string

  const PaymentHistory({
    required this.id,
    required this.description,
    required this.status,
    required this.amount,
    required this.coins,
    required this.currency,
    required this.address,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        description,
        status,
        amount,
        coins,
        currency,
        address,
        date,
      ];
}
