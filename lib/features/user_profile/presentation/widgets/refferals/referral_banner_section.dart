import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/features/referrals/presentation/providers/reffertal_banner_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/refferals/banner_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferralBannerSection extends ConsumerWidget {
  const ReferralBannerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(referralBannerNotifierProvider);
    final notifier = ref.read(referralBannerNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return switch (state) {
      // ─── Initial ─────────────────────────────
      ReferralBannerInitial() => Center(
          child: ElevatedButton(
            onPressed: () => notifier.fetchReferralBanners(),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: CommonText.bodyMedium(
              'Load Referral Banners',
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

      // ─── Loading ─────────────────────────────
      ReferralBannerLoading() => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: CircularProgressIndicator(),
          ),
        ),

      // ─── Error ───────────────────────────────
      ReferralBannerError(:final message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText.bodySmall(
                '⚠️ $message',
                color: colorScheme.error,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => notifier.fetchReferralBanners(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

      // ─── Success ─────────────────────────────
      ReferralBannerSuccess(:final banners) => Column(
          children: banners
              .map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: BannerCard(banner: b),
                ),
              )
              .toList(),
        ),
    };
  }
}
