import 'package:cointiply_app/features/user_profile/domain/usecases/upload_profile_picture.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'profile_providers.dart';

enum UploadProfileAvatarStatus {
  initial,
  loading,
  success,
  failure,
}

class UploadProfileAvatarState {
  final UploadProfileAvatarStatus status;
  final String? avatarUrl;
  final String? errorMessage;

  bool get isLoading => status == UploadProfileAvatarStatus.loading;

  UploadProfileAvatarState({
    this.status = UploadProfileAvatarStatus.initial,
    this.avatarUrl,
    this.errorMessage,
  });

  UploadProfileAvatarState copyWith({
    UploadProfileAvatarStatus? status,
    String? avatarUrl,
    String? errorMessage,
  }) {
    return UploadProfileAvatarState(
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final uploadProfileAvatarProvider = StateNotifierProvider.autoDispose<
    UploadProfileAvatarProvider, UploadProfileAvatarState>(
  (ref) {
    final uploadProfilePictureUsecase =
        ref.watch(uploadProfilePictureUseCaseProvider);
    return UploadProfileAvatarProvider(
      UploadProfileAvatarState(),
      uploadProfilePictureUsecase,
    );
  },
);

class UploadProfileAvatarProvider
    extends StateNotifier<UploadProfileAvatarState> {
  final UploadProfilePictureUsecase _uploadProfilePictureUsecase;
  UploadProfileAvatarProvider(super.state, this._uploadProfilePictureUsecase);

  Future<void> uploadAvatar() async {
    state = state.copyWith(
        status: UploadProfileAvatarStatus.loading, errorMessage: null);
    final image = await _pickImage();
    if (image == null) {
      state = state.copyWith(
        status: UploadProfileAvatarStatus.initial,
        errorMessage: null,
      );
      return;
    }
    final params = UploadProfilePictureParams(image: image);
    final result = await _uploadProfilePictureUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UploadProfileAvatarStatus.failure,
          errorMessage: failure.message ?? "Unknown error",
        );
      },
      (response) {
        state = state.copyWith(
          status: UploadProfileAvatarStatus.success,
          avatarUrl: response.avatarUrl,
        );
      },
    );
  }

  Future<PlatformFile?> _pickImage() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // Must be true for web to load bytes
      compressionQuality: 1,
    );
    if (file != null && file.files.isNotEmpty) {
      return file.files.first;
    } else {
      return null;
    }
  }
}
