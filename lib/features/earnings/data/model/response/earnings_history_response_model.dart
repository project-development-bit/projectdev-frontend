import 'package:cointiply_app/features/earnings/domain/entity/earnings_history_response.dart';

import 'earnings_history_data_model.dart';

class EarningsHistoryResponseModel extends EarningsHistoryResponse {
  const EarningsHistoryResponseModel({
    required super.success,
    required super.message,
    super.data,
  });

  factory EarningsHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return EarningsHistoryResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? EarningsHistoryDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data':
            data != null ? (data as EarningsHistoryDataModel).toJson() : null,
      };
}
