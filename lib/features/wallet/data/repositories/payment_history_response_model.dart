import 'package:gigafaucet/core/common/model/pagination_model.dart';
import 'package:gigafaucet/features/wallet/data/models/response/payment_history_model.dart';
import 'package:gigafaucet/features/wallet/domain/entity/payment_history_response_model.dart';

class PaymentHistoryResponseModel extends PaymentHistoryResponse {
  const PaymentHistoryResponseModel({
    required super.success,
    required super.payments,
    required super.pagination,
  });

  factory PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponseModel(
      success: json['success'] as bool? ?? false,
      payments: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  PaymentHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(
          json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': payments.map((e) => (e).toJson()).toList(),
      'pagination': (pagination).toJson(),
    };
  }
}
