


import 'dart:typed_data';

import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/upload_profile_avatar_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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

  final CropController _cropController = CropController();

  bool isCroppingImage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual<UploadProfileAvatarState>(
        uploadProfileAvatarProvider,
        (previous, next) async {
          if (next.status == UploadProfileAvatarStatus.success) {
            context.showSuccessSnackBar(
                message: "Avatar uploaded successfully");

            ref.read(currentUserProvider.notifier).getCurrentUser();
            ref
                .read(getProfileNotifierProvider.notifier)
                .fetchProfile(isLoading: false);
          }
        },
      );
    });
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

    final isLoading = ref.watch(uploadProfileAvatarProvider).isLoading;

    final isErrorState = ref.watch(uploadProfileAvatarProvider).status ==
        UploadProfileAvatarStatus.failure;
    final errorMessage = ref.watch(uploadProfileAvatarProvider).errorMessage;

    /// iscropping
    final isCropping = ref.watch(uploadProfileAvatarProvider).isCropping;
    final image = ref.watch(uploadProfileAvatarProvider).image;

    return DialogBgWidget(
      dialogHeight: dialogHeight,
      title: context.translate("change_your_avatar"),
      body: Padding(
        padding: context.isDesktop
            ? const EdgeInsets.all(32)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                .copyWith(top: 36),
        child: isCropping
            ? _cropWidget(
                image,
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
                      onTap: () {
                        isLoading
                            ? null
                            : ref
                                .read(uploadProfileAvatarProvider.notifier)
                                .pickAndCropImage();
                      },
                      width: context.isDesktop ? 250 : double.infinity,
                      isLoading: isLoading,
                      isDark: true,
                      backgroundColor: const Color(0xFF262626),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    SizedBox(
                        height: context.isDesktop ? 42 : 24,
                        child: isErrorState
                            ? Center(
                                child: CommonText.bodyMedium(
                                  errorMessage ??
                                      context.translate("something_went_wrong"),
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

  Widget _cropWidget(PlatformFile? image, WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Crop(
              filterQuality: FilterQuality.high,
              progressIndicator: CircularProgressIndicator(),
              baseColor: Colors.transparent,
              image: image?.bytes ?? Uint8List(0),
              maskColor: Colors.black.withAlpha(100),
              controller: _cropController,
              interactive: true,
              aspectRatio: 1,
              
              onStatusChanged: (cropStatus) {
                if (cropStatus == CropStatus.cropping) {
                  setState(() {
                    isCroppingImage = true;
                  });
                } else {
                  setState(() {
                    isCroppingImage = false;
                  });
                }
              },
              onCropped: (croppedData) async {
                if (croppedData is CropSuccess) {
                  await compute((message) {
                    ref.read(uploadProfileAvatarProvider.notifier).uploadAvatar(
                          name: image?.name ??
                              '${DateTime.now().toIso8601String()}.png',
                          size: croppedData.croppedImage.length,
                          bytes: croppedData.croppedImage,
                        );
                  }, "croppedData, image, ref);");
                }
                if (croppedData is CropFailure) {
                  ref.read(uploadProfileAvatarProvider.notifier).setErrorState(
                        "Failed to crop image. Please try again.",
                      );
                }
              }),
        ),
        SizedBox(height: 12),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: CustomUnderLineButtonWidget(
                title: context.translate("cancel"),
                onTap: ref.watch(uploadProfileAvatarProvider).isLoading
                    ? null
                    : () {
                        ref
                            .read(uploadProfileAvatarProvider.notifier)
                            .resetState();
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
                onTap: isCroppingImage
                    ? () {}
                    : () {
                        _cropController.crop();
                      },
                isLoading: isCroppingImage,
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
