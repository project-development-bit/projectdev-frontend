import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/upload_profile_avatar_provider.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/image_picker_provider.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/image_cropper_provider.dart';
import 'package:gigafaucet/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_image_crop/custom_image_crop.dart';

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
  final CustomImageCropController _cropController = CustomImageCropController();

  double _scaleIndex = 1;

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
    final uploadState = ref.watch(uploadProfileAvatarProvider);
    final pickerState = ref.watch(imagePickerProvider);
    final cropperState = ref.watch(imageCropperProvider);

    final isUploading = uploadState.isUploading;
    final isPicking = pickerState.isPicking;

    final isCropping = cropperState.status == ImageCropperStatus.cropping;

    final hasImageToCrop = (cropperState.originalImage != null);

    double dialogHeight;
    if (context.isDesktop) {
      if (hasImageToCrop || isCropping) {
        dialogHeight = 660;
      } else {
        dialogHeight = 480;
      }
    } else {
      if (context.isTablet) {
        if (hasImageToCrop || isCropping) {
          dialogHeight = 600;
        } else {
          dialogHeight = 400;
        }
      } else {
        if (hasImageToCrop || isCropping) {
          dialogHeight = 600;
        } else {
          dialogHeight = 450;
        }
      }
    }

    return DialogBgWidget(
      isOverlayLoading: isCropping || isUploading,
      dialogHeight: dialogHeight,
      title: context.translate("change_your_avatar"),
      body: Padding(
        padding: context.isDesktop
            ? const EdgeInsets.all(32)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                .copyWith(top: 36),
        child: SingleChildScrollView(
          child: hasImageToCrop
              ? _cropWidget(
                  cropperState.originalImage!,
                  ref,
                  context,
                )
              : Column(
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 360,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageCrop(
              cropController: _cropController,
              image: MemoryImage(imageData),
              shape: CustomCropShape.Square,
              canRotate: false,
              forceInsideCropArea: true,
              canMove: true,
              canScale: true,
              clipShapeOnCrop: false,
              borderRadius: 0,
              pathPaint: Paint()
                ..color = Colors.white
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2,
              cropPercentage: 0.8,
              drawPath: SolidCropPathPainter.drawPath,
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        Slider(
            value: _scaleIndex,
            max: 10,
            min: 1,
            onChanged: (value) {
              setState(() {
                _scaleIndex = value;
              });
              final scale = value.clamp(1, 10).toDouble();
              log(scale.toString());
              log(_cropController.cropImageData.toString());
              _cropController.addTransition(CropImageData(
                  scale: scale / (_cropController.cropImageData?.scale ?? 1)));
            }),
        SizedBox(height: 16),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: CustomUnderLineButtonWidget(
                title: context.translate("cancel"),
                onTap: () {
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
                onTap: () async {
                  _scaleIndex = 1;
                  try {
                    ref.read(imageCropperProvider.notifier).setLoading(true);

                    final croppedImage = await _cropController.onCropImage();
                    if (croppedImage != null) {
                      await ref
                          .read(uploadProfileAvatarProvider.notifier)
                          .uploadAvatar(
                            name: "avatar.png",
                            size: croppedImage.bytes.length,
                            bytes: croppedImage.bytes,
                          );
                    }
                  } catch (e) {
                    log("Error cropping image: $e");
                    if (context.mounted) {
                      context.showErrorSnackBar(
                          message: context.translate("failed_to_crop_image"));
                    }
                  } finally {
                    ref.read(imageCropperProvider.notifier).setLoading(false);
                  }
                },
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
