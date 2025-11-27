import 'package:equatable/equatable.dart';
import 'earnings_history_data.dart';

class EarningsHistoryResponse extends Equatable {
  final bool success;
  final String message;
  final EarningsHistoryData? data;

  const EarningsHistoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}
