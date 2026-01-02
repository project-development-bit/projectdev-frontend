import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_collect.dart';

class TreasureHuntCollectModel extends TreasureHuntCollect {
  const TreasureHuntCollectModel({
    required super.success,
    required super.message,
  });

  factory TreasureHuntCollectModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntCollectModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
