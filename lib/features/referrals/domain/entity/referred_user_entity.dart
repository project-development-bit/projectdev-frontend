import 'package:equatable/equatable.dart';

class ReferredUserEntity extends Equatable {
  final String username;
  final String date;
  final String fullDate;

  const ReferredUserEntity({
    required this.username,
    required this.date,
    required this.fullDate,
  });

  @override
  List<Object?> get props => [username, date, fullDate];
}
