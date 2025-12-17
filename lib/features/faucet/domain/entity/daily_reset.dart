import 'package:equatable/equatable.dart';

class DailyReset extends Equatable {
  const DailyReset({
    required this.resetTimeUtc,
    required this.nextResetAt,
    required this.timeUntilReset,
  });
  final DateTime resetTimeUtc;
  final DateTime nextResetAt;
  final TimeUntilReset timeUntilReset;
  @override
  List<Object?> get props => [resetTimeUtc, nextResetAt, timeUntilReset];
}

class TimeUntilReset extends Equatable {
  const TimeUntilReset({
    required this.minutes,
    required this.seconds,
    required this.totalSeconds,
    required this.hours,
  });
  final int hours;
  final int minutes;
  final int seconds;
  final int totalSeconds;
  @override
  List<Object?> get props => [minutes, seconds, totalSeconds];
}
