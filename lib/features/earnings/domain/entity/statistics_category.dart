import 'package:equatable/equatable.dart';

class StatisticsCategory extends Equatable {
  final int count;
  final int totalEarned;

  const StatisticsCategory({
    required this.count,
    required this.totalEarned,
  });

  @override
  List<Object?> get props => [count, totalEarned];
}
