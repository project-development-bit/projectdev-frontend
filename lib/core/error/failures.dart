import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// 
/// This abstract class is the foundation for all error handling
/// in the clean architecture. All failures should extend this class.
abstract class Failure extends Equatable {
  const Failure({this.message});

  /// Optional error message
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Server failure - when the API returns an error
class ServerFailure extends Failure {
  const ServerFailure({
    String? message,
    this.statusCode,
  }) : super(message: message);

  /// HTTP status code from the server
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Cache failure - when local storage operations fail
class CacheFailure extends Failure {
  const CacheFailure({String? message}) : super(message: message);
}

/// Network failure - when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({String? message}) : super(message: message);
}

/// Validation failure - when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure({String? message, this.field}) : super(message: message);

  /// The field that failed validation
  final String? field;

  @override
  List<Object?> get props => [message, field];
}

/// Authentication failure - when authentication is required or fails
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({String? message}) : super(message: message);
}

/// Authorization failure - when user doesn't have permission
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({String? message}) : super(message: message);
}

/// File operation failure - when file operations fail
class FileFailure extends Failure {
  const FileFailure({String? message}) : super(message: message);
}

/// General unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({String? message}) : super(message: message);
}