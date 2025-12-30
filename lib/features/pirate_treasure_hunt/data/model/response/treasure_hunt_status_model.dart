import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_status.dart';

class TreasureHuntStatusModel extends TreasureHuntStatus {
  const TreasureHuntStatusModel({
    required super.active,
    required super.canStart,
    required super.cooldownUntil,
    required super.huntId,
    required super.currentStep,
    required super.stepName,
    required super.stepDescription,
    required super.stepProgress,
    required super.completedTasks,
    required super.requiredTasks,
    required super.status,
    required super.availableTasks,
    required super.anyTaskAllowed,
    required super.startedAt,
    required super.userStatus,
    required super.userLevel,
  });

  factory TreasureHuntStatusModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntStatusModel(
      active: json['active'] ?? false,
      canStart: json['can_start'] ?? false,
      cooldownUntil: DateTime.tryParse(
        json['cooldown_until'] ?? '',
      ),
      huntId: json['hunt_id'] ?? 0,
      currentStep: json['current_step'] ?? 1,
      stepName: json['step_name'] ?? '',
      stepDescription: json['step_description'] ?? '',
      stepProgress: json['step_progress'] ?? '0/0',
      completedTasks: json['completed_tasks'] ?? 0,
      requiredTasks: json['required_tasks'] ?? 0,
      status: json['status'] ?? '',
      availableTasks: List<String>.from(
        json['available_tasks'] ?? const [],
      ),
      anyTaskAllowed: json['any_task_allowed'] ?? false,
      startedAt: DateTime.tryParse(
            json['started_at'] ?? '',
          ) ??
          DateTime.now(),
      userStatus: json['user_status'] ?? '',
      userLevel: json['user_level'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'active': active,
        'hunt_id': huntId,
        'current_step': currentStep,
        'step_name': stepName,
        'step_description': stepDescription,
        'step_progress': stepProgress,
        'completed_tasks': completedTasks,
        'required_tasks': requiredTasks,
        'status': status,
        'available_tasks': availableTasks,
        'any_task_allowed': anyTaskAllowed,
        'started_at': startedAt.toIso8601String(),
        'user_status': userStatus,
        'user_level': userLevel,
      };
}
