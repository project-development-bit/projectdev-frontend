import 'package:equatable/equatable.dart';

/// Domain entity for set security pin result
class SetSecurityPinResult extends Equatable {
  const SetSecurityPinResult({
    required this.success,
    required this.message,
    required this.securityPinEnabled,
  });

  final bool success;
  final String message;
  final bool securityPinEnabled;

  @override
  List<Object?> get props => [success, message, securityPinEnabled];
}
