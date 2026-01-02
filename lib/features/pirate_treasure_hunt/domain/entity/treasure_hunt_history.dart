import 'package:equatable/equatable.dart';
import 'treasure_hunt_history_item.dart';
import 'treasure_hunt_pagination.dart';

class TreasureHuntHistory extends Equatable {
  const TreasureHuntHistory({
    required this.success,
    required this.message,
    required this.items,
    required this.pagination,
  });

  final bool success;
  final String message;
  final List<TreasureHuntHistoryItem> items;
  final TreasureHuntPagination pagination;

  bool get hasMore => pagination.hasNextPage;

  @override
  List<Object?> get props => [
        success,
        message,
        items,
        pagination,
      ];
}
