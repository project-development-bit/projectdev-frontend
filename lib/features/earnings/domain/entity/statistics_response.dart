import 'package:equatable/equatable.dart';
import 'statistics_data.dart';

class StatisticsResponse extends Equatable {
  final bool success;
  final String message;
  final StatisticsData? data;

  const StatisticsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}
