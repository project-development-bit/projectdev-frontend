import 'package:equatable/equatable.dart';

class UserLevelState extends Equatable {
  final int level;
  final String currentStatus;
  final String currentSubLevel;
  final int xpTotal;
  final int xpCurrentLevel;
  final int xpNextLevel;
  final int xpInLevel;
  final int xpNeededInLevel;
  final double progressPercent;
  const UserLevelState({
    required this.level,
    required this.currentStatus,
    required this.currentSubLevel,
    required this.xpTotal,
    required this.xpCurrentLevel,
    required this.xpNextLevel,
    required this.xpInLevel,
    required this.xpNeededInLevel,
    required this.progressPercent,
  });

  @override
  List<Object?> get props => [
        level,
        currentStatus,
        currentSubLevel,
        xpTotal,
        xpCurrentLevel,
        xpNextLevel,
        xpInLevel,
        xpNeededInLevel,
        progressPercent,
      ];
}
