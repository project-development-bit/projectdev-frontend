// reward_state.dart

import 'package:cointiply_app/features/reward/domain/entities/reward_level.dart';
import 'package:cointiply_app/features/reward/domain/entities/user_level_state.dart';

enum GetRewardStatus {
  initial,
  loading,
  data,
  error,
}

class RewardState {
  final UserLevelState? userLevelState;
  final List<RewardLevel> levels;
  final GetRewardStatus status;
  final String selectedLevel;
  final String? error;

  final List<RewardLevel> visibleLevels;

  final bool isViewAll;

  const RewardState({
    // this.rewards,
    this.selectedLevel = '',
    this.userLevelState,
    this.levels = const [],
    this.status = GetRewardStatus.initial,
    this.error,
    this.visibleLevels = const [],
    this.isViewAll = false,
  });

  RewardState copyWith({
    UserLevelState? userLevelState,
    List<RewardLevel>? levels,
    GetRewardStatus? status,
    String? error,
    List<RewardLevel>? visibleLevels,
    bool? isViewAll,
    String? selectedLevel,
  }) {
    return RewardState(
      userLevelState: userLevelState ?? this.userLevelState,
      levels: levels ?? this.levels,
      status: status ?? this.status,
      error: error ?? this.error,
      visibleLevels: visibleLevels ?? this.visibleLevels,
      isViewAll: isViewAll ?? this.isViewAll,
      selectedLevel: selectedLevel ?? this.selectedLevel,
    );
  }
}
