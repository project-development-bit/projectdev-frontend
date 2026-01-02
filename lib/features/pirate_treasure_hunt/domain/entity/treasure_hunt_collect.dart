import 'package:equatable/equatable.dart';

class TreasureHuntCollect extends Equatable {
  const TreasureHuntCollect({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  TreasureHuntCollect copyWith({
    bool? success,
    String? message,
  }) {
    return TreasureHuntCollect(
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
      ];
}
