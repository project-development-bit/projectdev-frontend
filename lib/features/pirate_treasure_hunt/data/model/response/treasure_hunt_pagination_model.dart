import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_pagination.dart';

class TreasureHuntPaginationModel extends TreasureHuntPagination {
  const TreasureHuntPaginationModel({
    required super.currentPage,
    required super.limit,
    required super.total,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPrevPage,
  });

  factory TreasureHuntPaginationModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntPaginationModel(
      currentPage: json['currentPage'] ?? 1,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
