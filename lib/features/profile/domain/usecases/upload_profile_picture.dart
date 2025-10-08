import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for uploading profile picture
class UploadProfilePicture implements UseCase<String, UploadProfilePictureParams> {
  const UploadProfilePicture(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, String>> call(UploadProfilePictureParams params) async {
    return await repository.uploadProfilePicture(params.imagePath);
  }
}

/// Parameters for uploading profile picture
class UploadProfilePictureParams extends Equatable {
  const UploadProfilePictureParams({required this.imagePath});

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}