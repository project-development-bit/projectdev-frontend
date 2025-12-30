import 'package:equatable/equatable.dart';

class TreasureHuntPagination extends Equatable {
  const TreasureHuntPagination({
    required this.currentPage,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  final int currentPage;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  @override
  List<Object?> get props => [
        currentPage,
        limit,
        total,
        totalPages,
        hasNextPage,
        hasPrevPage,
      ];
}
