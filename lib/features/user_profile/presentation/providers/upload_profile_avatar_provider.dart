import 'package:cointiply_app/features/user_profile/domain/usecases/upload_profile_picture.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_providers.dart';

enum UploadProfileAvatarStatus {
  initial,
  uploading,
  success,
  failure,
}

class UploadProfileAvatarState {
  final UploadProfileAvatarStatus status;
  final String? avatarUrl;
  final String? errorMessage;

  bool get isUploading => status == UploadProfileAvatarStatus.uploading;
  bool get isSuccess => status == UploadProfileAvatarStatus.success;
  bool get isFailure => status == UploadProfileAvatarStatus.failure;

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

  UploadProfileAvatarState reset() {
    return UploadProfileAvatarState();
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

  /// Upload avatar with cropped image data
  Future<void> uploadAvatar({
    required String name,
    required int size,
    required Uint8List bytes,
  }) async {
    final image = PlatformFile(
      name: name,
      size: size,
      bytes: bytes,
    );

    state = state.copyWith(
      status: UploadProfileAvatarStatus.uploading,
      errorMessage: null,
    );

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

  /// Set error state
  void setError(String message) {
    state = state.copyWith(
      status: UploadProfileAvatarStatus.failure,
      errorMessage: message,
    );
  }

  /// Reset to initial state
  void reset() {
    state = UploadProfileAvatarState();
  }
}
