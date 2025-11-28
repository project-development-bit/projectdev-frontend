import 'package:equatable/equatable.dart';
import 'earnings_history_item.dart';
import 'earnings_pagination.dart';

class EarningsHistoryData extends Equatable {
  final List<EarningsHistoryItem> earnings;
  final EarningsPagination pagination;

  const EarningsHistoryData({
    required this.earnings,
    required this.pagination,
  });

  @override
  List<Object?> get props => [earnings, pagination];

  EarningsHistoryData copyWith({
    List<EarningsHistoryItem>? earnings,
    EarningsPagination? pagination,
  }) {
    return EarningsHistoryData(
      earnings: earnings ?? this.earnings,
      pagination: pagination ?? this.pagination,
    );
  }
}
