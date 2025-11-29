import 'package:cointiply_app/features/earnings/domain/entity/earnings_history_data.dart';

import 'earnings_history_item_model.dart';
import 'earnings_pagination_model.dart';

class EarningsHistoryDataModel extends EarningsHistoryData {
  const EarningsHistoryDataModel({
    required super.earnings,
    required super.pagination,
  });

  factory EarningsHistoryDataModel.fromJson(Map<String, dynamic> json) {
    return EarningsHistoryDataModel(
      earnings: (json['earnings'] as List? ?? [])
          .map((e) => EarningsHistoryItemModel.fromJson(e))
          .toList(),
      pagination: EarningsPaginationModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
        'earnings': earnings
            .map((e) => (e as EarningsHistoryItemModel).toJson())
            .toList(),
        'pagination': (pagination as EarningsPaginationModel).toJson(),
      };
}
