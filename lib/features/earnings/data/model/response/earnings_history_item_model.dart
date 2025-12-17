import 'package:gigafaucet/features/earnings/domain/entity/earnings_history_item.dart';

class EarningsHistoryItemModel extends EarningsHistoryItem {
  const EarningsHistoryItemModel({
    required super.id,
    required super.type,
    required super.category,
    required super.title,
    required super.amount,
    required super.currency,
    required super.timeAgo,
    required super.createdAt,
  });

  factory EarningsHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return EarningsHistoryItemModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      amount: json['amount'] ?? '',
      currency: json['currency'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.tryParse(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'category': category,
        'title': title,
        'amount': amount,
        'currency': currency,
        'timeAgo': timeAgo,
        'createdAt': createdAt.toIso8601String(),
      };
}
