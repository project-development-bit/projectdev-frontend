import 'package:gigafaucet/features/reward/data/models/response/user_level_state_model.dart';
import 'package:gigafaucet/features/reward/domain/entities/reward_data.dart';
import 'reward_level_model.dart';

class RewardDataModel extends RewardData {
  const RewardDataModel({
    required super.success,
    required super.userlevelState,
    required super.levels,
  });

  factory RewardDataModel.fromJson(Map<String, dynamic> json) {
    return RewardDataModel(
      success: json['success'] ?? false,
      userlevelState: UserLevelStateModel.fromJson(
        json['user_level_state'] ?? {},
      ),
      levels: (json['statuses'] as List? ?? [])
          .map((e) => RewardLevelModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'userlevel_state': (userlevelState as UserLevelStateModel).toJson(),
        'levels': levels.map((e) => (e as RewardLevelModel).toJson()).toList(),
      };
}
