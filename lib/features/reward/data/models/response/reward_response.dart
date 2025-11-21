import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'reward_data.dart';

part 'reward_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RewardResponse extends Equatable {
  final bool success;
  final RewardData? data;

  const RewardResponse({
    required this.success,
    this.data,
  });

  factory RewardResponse.fromJson(Map<String, dynamic> json) =>
      _$RewardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardResponseToJson(this);

  @override
  List<Object?> get props => [success, data];
}
