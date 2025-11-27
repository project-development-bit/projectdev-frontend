import 'package:equatable/equatable.dart';

class EarningsPagination extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const EarningsPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [total, page, limit, totalPages];
}
