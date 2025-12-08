import 'package:cointiply_app/core/common/model/pagination_model.dart';
import 'package:cointiply_app/features/wallet/data/models/response/payment_history_model.dart';
import 'package:equatable/equatable.dart';

class PaymentHistoryResponse extends Equatable {
  final bool success;
  final List<PaymentHistoryModel> payments;
  final PaginationModel pagination;

  const PaymentHistoryResponse({
    this.success = true,
    required this.payments,
    required this.pagination,
  });

  @override
  List<Object?> get props => [
        payments,
      ];
}
