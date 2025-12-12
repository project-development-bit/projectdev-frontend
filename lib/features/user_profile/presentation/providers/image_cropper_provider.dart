import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ImageCropperStatus {
  initial,
  cropping,
  cropped,
  cancelled,
  error,
}

class ImageCropperState {
  final ImageCropperStatus status;
  final PlatformFile? originalImage;
  final Uint8List? croppedImageBytes;
  final String? croppedImageName;
  final int? croppedImageSize;
  final String? errorMessage;

  bool get isCropping => status == ImageCropperStatus.cropping;
  bool get hasCropped => status == ImageCropperStatus.cropped && croppedImageBytes != null;

  ImageCropperState({
    this.status = ImageCropperStatus.initial,
    this.originalImage,
    this.croppedImageBytes,
    this.croppedImageName,
    this.croppedImageSize,
    this.errorMessage,
  });

  ImageCropperState copyWith({
    ImageCropperStatus? status,
    PlatformFile? originalImage,
    Uint8List? croppedImageBytes,
    String? croppedImageName,
    int? croppedImageSize,
    String? errorMessage,
  }) {
    return ImageCropperState(
      status: status ?? this.status,
      originalImage: originalImage ?? this.originalImage,
      croppedImageBytes: croppedImageBytes ?? this.croppedImageBytes,
      croppedImageName: croppedImageName ?? this.croppedImageName,
      croppedImageSize: croppedImageSize ?? this.croppedImageSize,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  ImageCropperState reset() {
    return ImageCropperState();
  }
}

final imageCropperProvider = StateNotifierProvider.autoDispose<
    ImageCropperNotifier, ImageCropperState>(
  (ref) => ImageCropperNotifier(),
);

class ImageCropperNotifier extends StateNotifier<ImageCropperState> {
  ImageCropperNotifier() : super(ImageCropperState());

  /// Set the image to be cropped
  void setImageForCropping(PlatformFile image) {
    state = state.copyWith(
      status: ImageCropperStatus.initial,
      originalImage: image,
      errorMessage: null,
    );
  }

  /// Start cropping process
  void startCropping() {
    state = state.copyWith(status: ImageCropperStatus.cropping);
  }

  /// Set the cropped image result
  void setCroppedImage({
    required String name,
    required int size,
    required Uint8List bytes,
  }) {
    state = state.copyWith(
      status: ImageCropperStatus.cropped,
      croppedImageBytes: bytes,
      croppedImageName: name,
      croppedImageSize: size,
      errorMessage: null,
    );
  }

  /// Cancel cropping
  void cancelCropping() {
    state = state.copyWith(
      status: ImageCropperStatus.cancelled,
      errorMessage: null,
    );
  }

  /// Reset the cropper state
  void reset() {
    state = ImageCropperState();
  }

  /// Set error state
  void setError(String message) {
    state = state.copyWith(
      status: ImageCropperStatus.error,
      errorMessage: message,
    );
  }
}
