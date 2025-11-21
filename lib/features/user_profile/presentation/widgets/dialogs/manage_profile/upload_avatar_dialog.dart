import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/upload_profile_avatar_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showUploadAvatarDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) => const UploadAvatarDialog(),
  );
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

    return DialogBgWidget(
      title: context.translate("change_your_avatar"),
      onClose: () {},
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            UserProfileImageWidget(
              size: 80,
            ),
            SizedBox(height: 32),
            ElevatedButton(
                onPressed: () {
                  isLoading
                      ? null
                      : ref
                          .read(uploadProfileAvatarProvider.notifier)
                          .uploadAvatar();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF262626),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CommonText.titleSmall(
                          context.translate("upload_your_new_avatar"),
                          color: Color(0xff98989A),
                        ),
                )),
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
      ),
    );
  }
}
