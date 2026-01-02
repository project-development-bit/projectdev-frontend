import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_history.dart';
import 'treasure_hunt_history_item_model.dart';
import 'treasure_hunt_pagination_model.dart';

class TreasureHuntHistoryModel extends TreasureHuntHistory {
  const TreasureHuntHistoryModel({
    required super.success,
    required super.message,
    required super.items,
    required super.pagination,
  });

  factory TreasureHuntHistoryModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntHistoryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      items: (json['data'] as List<dynamic>? ?? [])
          .map((e) => TreasureHuntHistoryItemModel.fromJson(e))
          .toList(),
      pagination:
          TreasureHuntPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}
