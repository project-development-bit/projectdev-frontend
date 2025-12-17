import 'package:gigafaucet/features/reward/domain/entities/sub_level.dart';
import 'package:equatable/equatable.dart';

class RewardLevel extends Equatable {
  final String id;
  final String label;
  final int minLevel;
  final int maxLevel;
  final List<SubLevel> subLevels;
  const RewardLevel({
    required this.id,
    required this.label,
    required this.minLevel,
    required this.maxLevel,
    required this.subLevels,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        minLevel,
        maxLevel,
        subLevels,
      ];
}
