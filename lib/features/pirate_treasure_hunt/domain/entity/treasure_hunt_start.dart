import 'package:equatable/equatable.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_start_data.dart';

class TreasureHuntStart extends Equatable {
  const TreasureHuntStart({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final TreasureHuntStartData? data;

  bool get hasActiveHunt => data != null;

  TreasureHuntStart copyWith({
    bool? success,
    String? message,
    TreasureHuntStartData? data,
  }) {
    return TreasureHuntStart(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
        data,
      ];
}
