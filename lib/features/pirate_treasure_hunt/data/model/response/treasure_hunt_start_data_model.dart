import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_start_data.dart';

class TreasureHuntStartDataModel extends TreasureHuntStartData {
  const TreasureHuntStartDataModel({
    required super.huntId,
    required super.currentStep,
    required super.stepName,
    required super.stepDescription,
    required super.requiredTasks,
    required super.availableTasks,
  });

  factory TreasureHuntStartDataModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntStartDataModel(
      huntId: json['hunt_id'] ?? 0,
      currentStep: json['current_step'] ?? 0,
      stepName: json['step_name'] ?? '',
      stepDescription: json['step_description'] ?? '',
      requiredTasks: json['required_tasks'] ?? 0,
      availableTasks: List<String>.from(json['available_tasks'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() => {
        'hunt_id': huntId,
        'current_step': currentStep,
        'step_name': stepName,
        'step_description': stepDescription,
        'required_tasks': requiredTasks,
        'available_tasks': availableTasks,
      };
}
