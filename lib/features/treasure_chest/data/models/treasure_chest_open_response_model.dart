import '../../domain/entities/treasure_chest_open_response.dart';
import 'treasure_chest_reward_model.dart';
import 'chests_remaining_model.dart';

/// Treasure chest open response model for data layer
///
/// Extends the TreasureChestOpenResponse entity with JSON serialization capabilities
class TreasureChestOpenResponseModel extends TreasureChestOpenResponse {
  const TreasureChestOpenResponseModel({
    required super.success,
    required super.message,
    required super.reward,
    required super.chestsRemaining,
  });

  /// Create TreasureChestOpenResponseModel from JSON response
  factory TreasureChestOpenResponseModel.fromJson(Map<String, dynamic> json) {
    return TreasureChestOpenResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      reward: TreasureChestRewardModel.fromJson(
        json['reward'] as Map<String, dynamic>? ?? {},
      ),
      chestsRemaining: ChestsRemainingModel.fromJson(
        json['chests_remaining'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'reward': (reward as TreasureChestRewardModel).toJson(),
      'chests_remaining': (chestsRemaining as ChestsRemainingModel).toJson(),
    };
  }

  /// Convert model to entity
  TreasureChestOpenResponse toEntity() {
    return TreasureChestOpenResponse(
      success: success,
      message: message,
      reward: (reward as TreasureChestRewardModel).toEntity(),
      chestsRemaining: (chestsRemaining as ChestsRemainingModel).toEntity(),
    );
  }
}
