import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/data/enum/user_level.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileImageWidget extends ConsumerWidget {
  const UserProfileImageWidget({super.key, this.size = 50, this.borderColor});
  final Color? borderColor;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = ref.watch(currentUserProvider).user;
    final isLoading = ref.watch(currentUserProvider).isLoading;
    final avatarUrl = currentUser?.avatarUrl;
    final userName = currentUser?.name ?? 'U';

    return Container(
      width: size + 20,
      height: size + 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isLoading
              ? Colors.transparent
              : currentUser?.currentStatus.color ?? UserLevel.bronze.color,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: (avatarUrl == null || avatarUrl.isEmpty) 
            ? Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    color: colorScheme.scrim.withValues(alpha: 0.5),
                    shape: BoxShape.circle),
                child: Center(
                  child: CommonText.titleLarge(
                    userName.isNotEmpty
                        ? userName.substring(0, 1).toUpperCase()
                        : 'A',
                  ),
                ),
              )
            : SizedBox(
                width: size,
                height: size,
                child: CircleAvatar(
                  backgroundColor: AppColors.websiteText,
                  child: CommonImage(
                    imageUrl: avatarUrl,
                    placeholder: Center(
                      child: CircularProgressIndicator(),
                    ),
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
      ),
    );
  }
}
