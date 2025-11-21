import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for uploading profile picture
class UploadProfilePictureUsecase
    implements
        UseCase<UploadProfileAvatarResponseModel, UploadProfilePictureParams> {
  const UploadProfilePictureUsecase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, UploadProfileAvatarResponseModel>> call(
      UploadProfilePictureParams params) async {
    return await repository.uploadProfilePicture(params.image);
  }
}

/// Parameters for uploading profile picture
class UploadProfilePictureParams extends Equatable {
  const UploadProfilePictureParams({required this.image});

  final PlatformFile image;

  @override
  List<Object> get props => [image];
}
