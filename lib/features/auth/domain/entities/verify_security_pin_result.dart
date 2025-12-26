import 'package:equatable/equatable.dart';

/// Domain entity for set security pin result
class VerifySecurityPinResult extends Equatable {
  const VerifySecurityPinResult({
    required this.success,
    required this.message,
    required this.verified,
  });

  final bool success;
  final String message;
  final bool verified;

  @override
  List<Object?> get props => [success, message, verified];
}
