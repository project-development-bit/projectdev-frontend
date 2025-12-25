import 'package:gigafaucet/features/reward/domain/entities/reward_level.dart';
import 'package:gigafaucet/features/reward/domain/entities/user_level_state.dart';
import 'package:equatable/equatable.dart';

class RewardData extends Equatable {
  final bool success;
  final UserLevelState userlevelState;
  final List<RewardLevel> levels;

  const RewardData({
    required this.userlevelState,
    required this.levels,
    required this.success,
  });

  @override
  List<Object?> get props => [
        userlevelState,
        levels,
        success,
      ];
}
