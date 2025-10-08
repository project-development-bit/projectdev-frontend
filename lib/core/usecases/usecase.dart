import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// 
/// [Type] - The return type of the use case
/// [Params] - The parameter type for the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't require parameters
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}