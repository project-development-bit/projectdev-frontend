import 'package:equatable/equatable.dart';

class FaucetCountdownState extends Equatable {
  final int hours;
  final int minutes;
  final int seconds;
  final bool isExpired;

  const FaucetCountdownState({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isExpired,
  });

  factory FaucetCountdownState.zero() {
    return const FaucetCountdownState(
      hours: 0,
      minutes: 0,
      seconds: 0,
      isExpired: true,
    );
  }

  @override
  List<Object?> get props => [hours, minutes, seconds, isExpired];
}
