import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/upload_profile_avatar_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/image_picker_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/image_cropper_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showUploadAvatarDialog(BuildContext context) {
  context.showManagePopup(
    child: const UploadAvatarDialog(),
  );
}

class UploadAvatarDialog extends ConsumerStatefulWidget {
  const UploadAvatarDialog({super.key});

  @override
  ConsumerState<UploadAvatarDialog> createState() => _UploadAvatarDialogState();
}

class _UploadAvatarDialogState extends ConsumerState<UploadAvatarDialog> {
  final _cropController = CropController(
    /// If not specified, [aspectRatio] will not be enforced.
    aspectRatio: 1,

    /// Specify in percentages (1 means full width and height). Defaults to the full image.
    defaultCrop: Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen to upload success
      ref.listenManual<UploadProfileAvatarState>(
        uploadProfileAvatarProvider,
        (previous, next) async {
          if (next.status == UploadProfileAvatarStatus.success) {
            context.showSuccessSnackBar(
                message: "Avatar uploaded successfully");
            ref.read(imageCropperProvider.notifier).reset();

            ref.read(currentUserProvider.notifier).getCurrentUser();
            ref
                .read(getProfileNotifierProvider.notifier)
                .fetchProfile(isLoading: false);
          } else if (next.status == UploadProfileAvatarStatus.failure) {
            context.showErrorSnackBar(
                message: next.errorMessage ?? "Failed to upload avatar");
          }
        },
      );

      // Listen to image picker
      ref.listenManual<ImagePickerState>(
        imagePickerProvider,
        (previous, next) {
          if (next.status == ImagePickerStatus.picked &&
              next.pickedFile != null) {
            // Set image for cropping
            ref
                .read(imageCropperProvider.notifier)
                .setImageForCropping(next.pickedFile!);
          } else if (next.status == ImagePickerStatus.error) {
            context.showErrorSnackBar(
                message: next.errorMessage ?? "Failed to pick image");
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _cropController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double dialogHeight = context.isDesktop
        ? 470
        : context.isTablet
            ? 400
            : 450;

    final uploadState = ref.watch(uploadProfileAvatarProvider);
    final pickerState = ref.watch(imagePickerProvider);
    final cropperState = ref.watch(imageCropperProvider);

    final isUploading = uploadState.isUploading;
    final isPicking = pickerState.isPicking;

    final hasImageToCrop = (cropperState.originalImage != null);

    return DialogBgWidget(
      dialogHeight: dialogHeight,
      title: context.translate("change_your_avatar"),
      body: Padding(
        padding: context.isDesktop
            ? const EdgeInsets.all(32)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                .copyWith(top: 36),
        child: hasImageToCrop
            ? _cropWidget(
                cropperState.originalImage!,
                ref,
                context,
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UserProfileImageWidget(
                      size: 150,
                    ),
                    SizedBox(height: 32),
                    CustomUnderLineButtonWidget(
                      title: context.translate("upload_your_new_avatar"),
                      onTap: (isUploading || isPicking)
                          ? null
                          : () {
                              ref
                                  .read(imagePickerProvider.notifier)
                                  .pickImage();
                            },
                      width: context.isDesktop ? 250 : double.infinity,
                      isLoading: isPicking,
                      isDark: true,
                      backgroundColor: const Color(0xFF262626),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    SizedBox(
                        height: context.isDesktop ? 42 : 24,
                        child: uploadState.isFailure
                            ? Center(
                                child: CommonText.bodyMedium(
                                  uploadState.errorMessage ??
                                      context.translate("something_went_wrong"),
                                  color: Colors.red,
                                ),
                              )
                            : pickerState.status == ImagePickerStatus.error
                                ? Center(
                                    child: CommonText.bodyMedium(
                                      pickerState.errorMessage ??
                                          context.translate(
                                              "something_went_wrong"),
                                      color: Colors.red,
                                    ),
                                  )
                                : null),
                    CommonText.bodyMedium(
                      context.translate("upload_new_avatar_desc"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _cropWidget(Uint8List imageData, WidgetRef ref, BuildContext context) {
    final uploadState = ref.watch(uploadProfileAvatarProvider);
    final isUploading = uploadState.isUploading;
    final cropperState = ref.watch(imageCropperProvider);
    final isCropping = cropperState.status == ImageCropperStatus.cropping;

    return Column(
      children: [
        Expanded(
          child: CropImage(
            image: Image.memory(imageData),
            controller: _cropController,
            loadingPlaceholder: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: CustomUnderLineButtonWidget(
                title: context.translate("cancel"),
                onTap: (isUploading || isCropping)
                    ? null
                    : () {
                        ref.read(imageCropperProvider.notifier).reset();
                        ref.read(imagePickerProvider.notifier).reset();
                        ref.read(uploadProfileAvatarProvider.notifier).reset();
                      },
                isDark: true,
                backgroundColor: const Color(0xFF262626),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: CustomUnderLineButtonWidget(
                title: context.translate("crop_and_upload"),
                onTap: (isCropping || isUploading)
                    ? null
                    : () async {
                        ref.read(imageCropperProvider.notifier).startCropping();
                        ui.Image bitmap = await _cropController.croppedBitmap();
                        final data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
                        final bytes = data!.buffer.asUint8List();
                        await ref.read(uploadProfileAvatarProvider.notifier).uploadAvatar(
                              name: "avatar.png", size: bytes.length, bytes: bytes,
                            );

                      },
                isLoading: isCropping || isUploading,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        )
      ],
    );
  }
}
