import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_start.dart';
import 'treasure_hunt_start_data_model.dart';

class TreasureHuntStartModel extends TreasureHuntStart {
  const TreasureHuntStartModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory TreasureHuntStartModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntStartModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? TreasureHuntStartDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data is TreasureHuntStartDataModel
            ? (data as TreasureHuntStartDataModel).toJson()
            : null,
      };
}
