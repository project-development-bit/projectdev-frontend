import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ImagePickerStatus {
  initial,
  picking,
  picked,
  cancelled,
  error,
}

class ImagePickerState {
  final ImagePickerStatus status;
  final PlatformFile? pickedFile;
  final String? errorMessage;

  bool get isPicking => status == ImagePickerStatus.picking;
  bool get hasPicked => status == ImagePickerStatus.picked && pickedFile != null;

  ImagePickerState({
    this.status = ImagePickerStatus.initial,
    this.pickedFile,
    this.errorMessage,
  });

  ImagePickerState copyWith({
    ImagePickerStatus? status,
    PlatformFile? pickedFile,
    String? errorMessage,
  }) {
    return ImagePickerState(
      status: status ?? this.status,
      pickedFile: pickedFile ?? this.pickedFile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  ImagePickerState reset() {
    return ImagePickerState();
  }
}

final imagePickerProvider = StateNotifierProvider.autoDispose<
    ImagePickerNotifier, ImagePickerState>(
  (ref) => ImagePickerNotifier(),
);

class ImagePickerNotifier extends StateNotifier<ImagePickerState> {
  ImagePickerNotifier() : super(ImagePickerState());

  /// Pick an image from the device
  Future<PlatformFile?> pickImage() async {
    state = state.copyWith(status: ImagePickerStatus.picking);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: kIsWeb, // Must be true for web to load bytes
        compressionQuality: 40,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        state = state.copyWith(
          status: ImagePickerStatus.picked,
          pickedFile: file,
          errorMessage: null,
        );
        return file;
      } else {
        // User cancelled
        state = state.copyWith(
          status: ImagePickerStatus.cancelled,
          errorMessage: null,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        status: ImagePickerStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Reset the picker state
  void reset() {
    state = ImagePickerState();
  }

  /// Set error state
  void setError(String message) {
    state = state.copyWith(
      status: ImagePickerStatus.error,
      errorMessage: message,
    );
  }
}
