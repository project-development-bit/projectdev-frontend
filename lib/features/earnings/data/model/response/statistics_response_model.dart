import 'package:cointiply_app/features/earnings/domain/entity/statistics_response.dart';

import 'statistics_data_model.dart';

class StatisticsResponseModel extends StatisticsResponse {
  const StatisticsResponseModel({
    required super.success,
    required super.message,
    super.data,
  });

  factory StatisticsResponseModel.fromJson(Map<String, dynamic> json) {
    return StatisticsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? StatisticsDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data != null ? (data as StatisticsDataModel).toJson() : null,
      };
}
