import 'package:cointiply_app/features/user_profile/domain/usecases/upload_profile_picture.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final PlatformFile? image;
  final bool
      isCroppingLoading;// this is for the cropping loading indicator after selecting the image 

  bool get isLoading => status == UploadProfileAvatarStatus.loading;

  bool get isCropping =>
      status == UploadProfileAvatarStatus.initial && image != null;

  UploadProfileAvatarState({
    this.status = UploadProfileAvatarStatus.initial,
    this.avatarUrl,
    this.errorMessage,
    this.image,
    this.isCroppingLoading = false,
  });

  UploadProfileAvatarState copyWith({
    UploadProfileAvatarStatus? status,
    String? avatarUrl,
    String? errorMessage,
    PlatformFile? image,
    bool? isCroppingLoading,
  }) {
    return UploadProfileAvatarState(
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      image: image ?? this.image,
      isCroppingLoading: isCroppingLoading ?? this.isCroppingLoading,
    );
  }

  UploadProfileAvatarState setImage(PlatformFile? newImage) {
    return UploadProfileAvatarState(
      status: UploadProfileAvatarStatus.initial,
      avatarUrl: avatarUrl,
      errorMessage: errorMessage,
      image: newImage,
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

  Future<void> pickAndCropImage() async {
    // Don't set loading state immediately to avoid UI jank
    // The file picker dialog will provide its own loading indicator
    final image = await _pickImage();

    // Only update state after picker completes
    state = state.copyWith(
      status: UploadProfileAvatarStatus.loading,
    );
    if (image != null) {
      state = state.setImage(image);
    } else {
      // Reset to initial if user cancelled
      state = state.copyWith(
        status: UploadProfileAvatarStatus.initial,
        errorMessage: null,
      );
    }
  }

  Future<void> uploadAvatar({required String name , required int size, required Uint8List bytes}) async {
    final image = PlatformFile(
      name: name,
      size: size,
      bytes: bytes,
    );
    state = state.copyWith(
        status: UploadProfileAvatarStatus.loading, errorMessage: null);
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
      withData: kIsWeb, // Must be true for web to load bytes
      compressionQuality: 40,
    );
    if (file != null && file.files.isNotEmpty) {
      return file.files.first;
    } else {
      return null;
    }
  }

  void setErrorState(String s) {
    state = state.copyWith(
      status: UploadProfileAvatarStatus.failure,
      errorMessage: s,
    );
  }

  void resetState() {
    state = UploadProfileAvatarState();
  }
}
