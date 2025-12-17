import 'package:equatable/equatable.dart';

class FaucetStreakDay extends Equatable {
  const FaucetStreakDay({
    required this.day,
    required this.reward,
    required this.target,
  });

  final int day;
  final int reward;
  final int target;
  @override
  List<Object?> get props => [day, reward];
}
