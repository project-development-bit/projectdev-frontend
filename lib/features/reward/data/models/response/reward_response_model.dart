import 'package:cointiply_app/features/reward/domain/entities/reward_response.dart';
import 'reward_data_model.dart';

class RewardResponseModel extends RewardResponse {
  const RewardResponseModel({
    required super.success,
    super.data,
  });

  factory RewardResponseModel.fromJson(Map<String, dynamic> json) {
    return RewardResponseModel(
      success: json['success'],
      data:
          json['data'] != null ? RewardDataModel.fromJson(json['data']) : null,
    );
  }
  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data != null ? (data as RewardDataModel).toJson() : null,
      };

  @override
  List<Object?> get props => [success, data];
}
