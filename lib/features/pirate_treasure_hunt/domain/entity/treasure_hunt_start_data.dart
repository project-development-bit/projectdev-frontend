import 'package:equatable/equatable.dart';

class TreasureHuntStartData extends Equatable {
  const TreasureHuntStartData({
    required this.huntId,
    required this.currentStep,
    required this.stepName,
    required this.stepDescription,
    required this.requiredTasks,
    required this.availableTasks,
  });

  final int huntId;
  final int currentStep;
  final String stepName;
  final String stepDescription;
  final int requiredTasks;
  final List<String> availableTasks;

  bool get isStepCompleted => requiredTasks == 0;

  TreasureHuntStartData copyWith({
    int? huntId,
    int? currentStep,
    String? stepName,
    String? stepDescription,
    int? requiredTasks,
    List<String>? availableTasks,
  }) {
    return TreasureHuntStartData(
      huntId: huntId ?? this.huntId,
      currentStep: currentStep ?? this.currentStep,
      stepName: stepName ?? this.stepName,
      stepDescription: stepDescription ?? this.stepDescription,
      requiredTasks: requiredTasks ?? this.requiredTasks,
      availableTasks: availableTasks ?? this.availableTasks,
    );
  }

  @override
  List<Object?> get props => [
        huntId,
        currentStep,
        stepName,
        stepDescription,
        requiredTasks,
        availableTasks,
      ];
}
