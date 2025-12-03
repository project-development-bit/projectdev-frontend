class TransactionModel {
  final String id;
  final String description;
  final String status;
  final String amount; // e.g. "$10.00" – String (formatted)
  final String coins; // e.g. "1500 coins"
  final String currency; // e.g. "USD" or "$"
  final String address;
  final String date; // formatted date string

  TransactionModel({
    required this.id,
    required this.description,
    required this.status,
    required this.amount,
    required this.coins,
    required this.currency,
    required this.address,
    required this.date,
  });

  /// Factory – read from API JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"]?.toString() ?? "",
      description: json["description"] ?? "",
      status: json["status"] ?? "",
      amount: json["amount"]?.toString() ?? "",
      coins: json["coins"]?.toString() ?? "",
      currency: json["currency"] ?? "",
      address: json["address"] ?? "",
      date: json["date"] ?? "",
    );
  }

  /// Convert to JSON – useful for mock data or caching
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "status": status,
      "amount": amount,
      "coins": coins,
      "currency": currency,
      "address": address,
      "date": date,
    };
  }
}
