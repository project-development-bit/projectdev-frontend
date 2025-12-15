import 'package:equatable/equatable.dart';

class FaucetStreakDay extends Equatable {
  const FaucetStreakDay({
    required this.day,
    required this.reward,
  });

  final int day;
  final int reward;

  @override
  List<Object?> get props => [day, reward];
}
