import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUserState = ref.watch(currentUserProvider);

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Banner Section ────────────────────────────────
            Container(
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/bg/profile_bg.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                )),

            // ─── Profile Info Card ─────────────────────────────
            Container(
              color: colorScheme.surfaceContainerHighest,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  currentUserState.user?.name.isNotEmpty == true
                      ? Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CommonText.titleLarge(
                              currentUserState.user!.name
                                  .substring(0, 1)
                                  .toUpperCase(),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 56,
                          height: 56,
                          child: const CircleAvatar(
                            backgroundColor: AppColors.websiteText,
                            child: Icon(Icons.person,
                                size: 46, color: Colors.white),
                          ),
                        ),

                  const SizedBox(width: 16),

                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        CommonText.titleMedium(
                          currentUserState.user?.name ?? 'Loading...',
                        ),
                        const SizedBox(height: 4),

                        // Level
                        CommonText.labelMedium(
                          "Level 1",
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),

                        // Info row (username, location, joined)
                        context.isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText.labelSmall(
                                    currentUserState.user?.name ?? 'Loading...',
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.pin_drop,
                                        size: 12,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      CommonText.labelSmall(
                                        "Thailand",
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 12,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      CommonText.labelSmall(
                                        "Joined 6 years ago",
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  CommonText.labelSmall(
                                    currentUserState.user?.name ?? 'Loading...',
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.pin_drop,
                                    size: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  CommonText.labelSmall(
                                    "Thailand",
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  CommonText.labelSmall(
                                    "Joined 6 years ago",
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
