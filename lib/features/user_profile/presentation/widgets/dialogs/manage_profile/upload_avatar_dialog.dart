import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/upload_profile_avatar_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showUploadAvatarDialog(BuildContext context) {
  context.showManagePopup(
    child: const UploadAvatarDialog(),
  );
}

class UploadAvatarDialog extends ConsumerWidget {
  const UploadAvatarDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double dialogHeight = context.isDesktop
        ? 470
        : context.isTablet
            ? 400
            : 450;

    final isLoading = ref.watch(uploadProfileAvatarProvider).isLoading;

    final isErrorState = ref.watch(uploadProfileAvatarProvider).status ==
        UploadProfileAvatarStatus.failure;
    final errorMessage = ref.watch(uploadProfileAvatarProvider).errorMessage;

    ref.listen<UploadProfileAvatarState>(
      uploadProfileAvatarProvider,
      (previous, next) async {
        if (next.status == UploadProfileAvatarStatus.success) {
          context.showSuccessSnackBar(message: "Avatar uploaded successfully");
         
          ref.read(currentUserProvider.notifier).getCurrentUser();
          ref
              .read(getProfileNotifierProvider.notifier)
              .fetchProfile(isLoading: false);
      
          if (context.mounted) {
            context.pop();
          }
        }
      },
    );

    return DialogBgWidget(
      dialogHeight: dialogHeight,
      title: context.translate("change_your_avatar"),
      body: Padding(
        padding: context.isDesktop
            ? const EdgeInsets.all(32)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                .copyWith(top: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            UserProfileImageWidget(
              size: 80,
            ),
            SizedBox(height: 32),
            CustomUnderLineButtonWidget(
              title: context.translate("upload_your_new_avatar"),
              onTap: () {
                isLoading
                    ? null
                    : ref
                        .read(uploadProfileAvatarProvider.notifier)
                        .uploadAvatar();
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
    );
  }
}
