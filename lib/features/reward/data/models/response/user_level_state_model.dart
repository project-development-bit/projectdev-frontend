import 'package:cointiply_app/features/reward/domain/entities/user_level_state.dart';

class UserLevelStateModel extends UserLevelState {
  const UserLevelStateModel({
    required super.level,
    required super.currentStatus,
    required super.currentSubLevel,
    required super.xpTotal,
    required super.xpCurrentLevel,
    required super.xpNextLevel,
    required super.xpInLevel,
    required super.xpNeededInLevel,
    required super.progressPercent,
  });
  factory UserLevelStateModel.fromJson(Map<String, dynamic> json) {
    return UserLevelStateModel(
      level: json['level'] ?? 0,
      currentStatus: json['current_status'] ?? "",
      currentSubLevel: json['current_sub_level'] ?? "",
      xpTotal: json['xp_total'] ?? 0,
      xpCurrentLevel: json['xp_current_level'] ?? 0,
      xpNextLevel: json['xp_next_level'] ?? 0,
      xpInLevel: json['xp_in_level'] ?? 0,
      xpNeededInLevel: json['xp_needed_in_level'] ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'current_status': currentStatus,
        'current_sub_level': currentSubLevel,
        'xp_total': xpTotal,
        'xp_current_level': xpCurrentLevel,
        'xp_next_level': xpNextLevel,
        'xp_in_level': xpInLevel,
        'xp_needed_in_level': xpNeededInLevel,
        'progress_percent': progressPercent,
      };
}
