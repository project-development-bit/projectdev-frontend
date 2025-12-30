import 'package:equatable/equatable.dart';

class TreasureHuntStatus extends Equatable {
  const TreasureHuntStatus({
    required this.active,
    required this.huntId,
    required this.currentStep,
    required this.stepName,
    required this.stepDescription,
    required this.stepProgress,
    required this.completedTasks,
    required this.requiredTasks,
    required this.status,
    required this.availableTasks,
    required this.anyTaskAllowed,
    required this.startedAt,
    required this.userStatus,
    required this.userLevel,
  });

  final bool active;
  final int huntId;
  final int currentStep;
  final String stepName;
  final String stepDescription;
  final String stepProgress;
  final int completedTasks;
  final int requiredTasks;
  final String status;
  final List<String> availableTasks;
  final bool anyTaskAllowed;
  final DateTime startedAt;
  final String userStatus;
  final int userLevel;

  /// Convenience getters
  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isLocked => !active;

  double get progressRatio =>
      requiredTasks == 0 ? 0 : completedTasks / requiredTasks;

  TreasureHuntStatus copyWith({
    bool? active,
    int? huntId,
    int? currentStep,
    String? stepName,
    String? stepDescription,
    String? stepProgress,
    int? completedTasks,
    int? requiredTasks,
    String? status,
    List<String>? availableTasks,
    bool? anyTaskAllowed,
    DateTime? startedAt,
    String? userStatus,
    int? userLevel,
  }) {
    return TreasureHuntStatus(
      active: active ?? this.active,
      huntId: huntId ?? this.huntId,
      currentStep: currentStep ?? this.currentStep,
      stepName: stepName ?? this.stepName,
      stepDescription: stepDescription ?? this.stepDescription,
      stepProgress: stepProgress ?? this.stepProgress,
      completedTasks: completedTasks ?? this.completedTasks,
      requiredTasks: requiredTasks ?? this.requiredTasks,
      status: status ?? this.status,
      availableTasks: availableTasks ?? this.availableTasks,
      anyTaskAllowed: anyTaskAllowed ?? this.anyTaskAllowed,
      startedAt: startedAt ?? this.startedAt,
      userStatus: userStatus ?? this.userStatus,
      userLevel: userLevel ?? this.userLevel,
    );
  }

  @override
  List<Object?> get props => [
        active,
        huntId,
        currentStep,
        stepName,
        stepDescription,
        stepProgress,
        completedTasks,
        requiredTasks,
        status,
        availableTasks,
        anyTaskAllowed,
        startedAt,
        userStatus,
        userLevel,
      ];
}
