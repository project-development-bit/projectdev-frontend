import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileImageWidget extends ConsumerWidget {
  const UserProfileImageWidget({super.key, this.size = 50});
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUserState = ref.watch(currentUserProvider);
    return Container(
      width: size + 20,
      height: size + 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFF00A0DC),
          width: 4,
        ),
      ),
      child: ClipOval(
        child: currentUserState.user?.name.isNotEmpty == true
            ? Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    color: colorScheme.scrim.withValues(alpha: 0.5),
                    shape: BoxShape.circle),
                child: Center(
                  child: CommonText.titleLarge(
                    currentUserState.user!.name.substring(0, 1).toUpperCase(),
                  ),
                ),
              )
            : SizedBox(
                width: size,
                height: size,
                child: CircleAvatar(
                  backgroundColor: AppColors.websiteText,
                  child: Icon(Icons.person, size: 28, color: Colors.white),
                ),
              ),
      ),
    );
  }
}
