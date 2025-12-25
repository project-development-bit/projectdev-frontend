import 'package:gigafaucet/core/error/error_model.dart';
import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
///
/// This abstract class is the foundation for all error handling
/// in the clean architecture. All failures should extend this class.
abstract class Failure extends Equatable {
  const Failure({this.message, this.errorModel});

  /// Optional error message
  final String? message;

  final ErrorModel? errorModel;

  @override
  List<Object?> get props => [message];
}

/// Server failure - when the API returns an error
class ServerFailure extends Failure {
  const ServerFailure({
    super.message,
    this.statusCode,
    super.errorModel,
  });

  /// HTTP status code from the server
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Cache failure - when local storage operations fail
class CacheFailure extends Failure {
  const CacheFailure({super.message, super.errorModel});
}

/// Network failure - when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.errorModel});
}

/// Validation failure - when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure({super.message, this.field, super.errorModel});

  /// The field that failed validation
  final String? field;

  @override
  List<Object?> get props => [message, field];
}

/// Authentication failure - when authentication is required or fails
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message, super.errorModel});
}

/// Authorization failure - when user doesn't have permission
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({super.message, super.errorModel});
}

/// File operation failure - when file operations fail
class FileFailure extends Failure {
  const FileFailure({super.message, super.errorModel});
}

/// Database failure - when database operations fail
class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message, super.errorModel});
}

/// General unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message, super.errorModel});
}
