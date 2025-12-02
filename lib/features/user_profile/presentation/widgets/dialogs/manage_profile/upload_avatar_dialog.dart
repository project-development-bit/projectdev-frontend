import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/upload_profile_avatar_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showUploadAvatarDialog(BuildContext context) {
  context.showManagePopup(
      child: const UploadAvatarDialog(),
      title: context.translate("change_your_avatar"));
}

class UploadAvatarDialog extends ConsumerWidget {
  const UploadAvatarDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(uploadProfileAvatarProvider).isLoading;

    final isErrorState = ref.watch(uploadProfileAvatarProvider).status ==
        UploadProfileAvatarStatus.failure;
    final errorMessage = ref.watch(uploadProfileAvatarProvider).errorMessage;

    ref.listen<UploadProfileAvatarState>(
      uploadProfileAvatarProvider,
      (previous, next) {
        if (next.status == UploadProfileAvatarStatus.success) {
          ref.read(currentUserProvider.notifier).getCurrentUser();
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.all(32),
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
            width: 250,
            isLoading: isLoading,
            isDark: true,
            backgroundColor: const Color(0xFF262626),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          SizedBox(
              height: 42,
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
    );
  }
}
