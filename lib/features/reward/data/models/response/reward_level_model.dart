import 'package:gigafaucet/features/reward/data/models/response/sub_level_model.dart';
import 'package:gigafaucet/features/reward/domain/entities/reward_level.dart';

class RewardLevelModel extends RewardLevel {
  const RewardLevelModel({
    required super.id,
    required super.label,
    required super.minLevel,
    required super.maxLevel,
    required super.subLevels,
  });

  factory RewardLevelModel.fromJson(Map<String, dynamic> json) {
    return RewardLevelModel(
      id: json['id'] ?? "",
      label: json['label'] ?? "",
      minLevel: json['min_level'] ?? 0,
      maxLevel: json['max_level'] ?? 0,
      subLevels: json['sub_levels'] != null
          ? (json['sub_levels'] as List<dynamic>?)
                  ?.map(
                      (e) => SubLevelModel.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              []
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'min_level': minLevel,
      'max_level': maxLevel,
      'sub_levels':
          subLevels.map((e) => (e as SubLevelModel).toJson()).toList(),
    };
  }
}
