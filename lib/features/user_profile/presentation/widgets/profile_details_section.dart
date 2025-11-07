import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';

class ProfileDetailsSection extends ConsumerWidget {
  const ProfileDetailsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final currentUserState = ref.watch(currentUserProvider);

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText.titleLarge(
              localizations?.translate("profile_details_title") ?? '',
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 24),
            ProfileDetailsInfo(
              label: localizations?.translate("profile_full_name") ?? '',
              value: currentUserState.user?.name ?? 'Loading...',
            ),
            ProfileDetailsInfo(
              label: localizations?.translate("profile_username") ?? '',
              value: currentUserState.user?.name ?? 'Loading...',
            ),
            ProfileDetailsInfo(
              label: localizations?.translate("profile_email") ?? '',
              value: currentUserState.user?.email ?? 'Loading...',
            ),
            ProfileDetailsInfo(
              label: localizations?.translate("profile_country") ?? '',
              value: "Thailand",
            ),
            ProfileDetailsInfo(
              label: localizations?.translate("profile_referred_by") ?? '',
              value: "EwAN",
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                border: Border.all(
                  color: colorScheme.tertiaryContainer,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: colorScheme.tertiary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.titleMedium(
                          localizations?.translate("profile_2fa_title") ?? '',
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 4),
                        CommonText.bodySmall(
                          localizations?.translate("profile_2fa_description") ??
                              '',
                          color: colorScheme.onSurfaceVariant,
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

class ProfileDetailsInfo extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailsInfo({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText.bodyMedium(
            label,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          CommonText.bodyMedium(
            value,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
