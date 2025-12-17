import 'package:gigafaucet/features/faucet/domain/entity/daily_reset.dart';

class DailyResetModel extends DailyReset {
  const DailyResetModel({
    required super.resetTimeUtc,
    required super.nextResetAt,
    required super.timeUntilReset,
  });

  factory DailyResetModel.fromJson(Map<String, dynamic>? json) {
    return DailyResetModel(
        resetTimeUtc: json != null && json['reset_time_utc'] != null
            ? DateTime.tryParse(json['reset_time_utc'] as String) ??
                DateTime.now()
            : DateTime.now(),
        nextResetAt: json != null && json['next_reset_at'] != null
            ? DateTime.tryParse(json['next_reset_at'] as String) ??
                DateTime.now()
            : DateTime.now(),
        timeUntilReset: json != null && json['time_until_reset'] != null
            ? TimeUntilResetModel.fromJson(
                json['time_until_reset'] as Map<String, dynamic>?)
            : TimeUntilResetModel.fromJson(null));
  }

  Map<String, dynamic> toJson() => {
        'reset_time_utc': resetTimeUtc.toIso8601String(),
        'next_reset_at': nextResetAt.toIso8601String(),
        'time_until_reset': (timeUntilReset as TimeUntilResetModel).toJson(),
      };
}

class TimeUntilResetModel extends TimeUntilReset {
  const TimeUntilResetModel({
    required super.hours,
    required super.minutes,
    required super.seconds,
    required super.totalSeconds,
  });

  factory TimeUntilResetModel.fromJson(Map<String, dynamic>? json) {
    return TimeUntilResetModel(
      hours: json != null && json['hours'] != null ? json['hours'] as int : 0,
      minutes:
          json != null && json['minutes'] != null ? json['minutes'] as int : 0,
      seconds:
          json != null && json['seconds'] != null ? json['seconds'] as int : 0,
      totalSeconds: json != null && json['total_seconds'] != null
          ? json['total_seconds'] as int
          : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds,
        'total_seconds': totalSeconds,
      };
}
