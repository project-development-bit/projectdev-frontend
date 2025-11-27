import 'package:equatable/equatable.dart';

class EarningsHistoryItem extends Equatable {
  final int id;
  final String type;
  final String category;
  final String title;
  final int amount;
  final String currency;
  final String timeAgo;
  final DateTime createdAt;

  const EarningsHistoryItem({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.amount,
    required this.currency,
    required this.timeAgo,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        category,
        title,
        amount,
        currency,
        timeAgo,
        createdAt,
      ];
}
