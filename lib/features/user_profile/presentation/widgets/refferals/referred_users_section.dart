import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/referrals/presentation/providers/referral_users_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/refferals/referred_users_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferredUsersSection extends ConsumerWidget {
  const ReferredUsersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final isMobile = context.isMobile;

    final state = ref.watch(referralUsersNotifierProvider);
    final notifier = ref.read(referralUsersNotifierProvider.notifier);

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(16),
        child: switch (state) {
          ReferralUsersLoading() => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(),
              ),
            ),
          ReferralUsersError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    CommonText.bodySmall(
                      message,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: notifier.fetchReferralUsers,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ReferralUsersSuccess(:final users) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText.titleMedium(
                      localizations?.translate('referrals_users_title') ??
                          'Referred Users',
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          CommonText.bodySmall(
                            localizations?.translate('referrals_filter_type') ??
                                'Filter By Type',
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CommonText.bodySmall(
                  localizations?.translate('referrals_users_desc') ??
                      'View users you have referred to Cointiply',
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),

                // Table
                ReferredUsersTable(
                  users: users,
                  isMobile: isMobile,
                  localizations: localizations,
                ),
              ],
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
