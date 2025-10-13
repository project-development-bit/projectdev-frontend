import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// 
/// [T] - The return type of the use case
/// [P] - The parameter type for the use case
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// Use case that doesn't require parameters
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}