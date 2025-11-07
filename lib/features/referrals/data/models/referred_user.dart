import 'package:cointiply_app/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'referred_user.g.dart';

@JsonSerializable(createFactory: true, createToJson: true)
class ReferredUser extends Equatable {
  final String username;
  final String date;
  @JsonKey(name: 'full_date')
  final String fullDate;

  const ReferredUser({
    required this.username,
    required this.date,
    required this.fullDate,
  });

  factory ReferredUser.fromJson(Map<String, dynamic> json) =>
      _$ReferredUserFromJson(json);

  Map<String, dynamic> toJson() => _$ReferredUserToJson(this);

  ReferredUserEntity toEntity() => ReferredUserEntity(
        username: username,
        date: date,
        fullDate: fullDate,
      );

  @override
  List<Object?> get props => [username, date, fullDate];
}
