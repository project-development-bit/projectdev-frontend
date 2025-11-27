import 'package:cointiply_app/features/reward/domain/entities/reward_data.dart';
import 'package:equatable/equatable.dart';

class RewardResponse extends Equatable {
  final bool success;
  final RewardData? data;

  const RewardResponse({
    required this.success,
    this.data,
  });

  @override
  List<Object?> get props => [success, data];
}
