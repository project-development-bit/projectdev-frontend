import 'package:gigafaucet/core/common/common_rich_text_with_icon.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/reward/presentation/providers/reward_provider.dart';
import 'package:gigafaucet/features/reward/presentation/providers/reward_state.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/features/reward/presentation/widgets/reward_xp_prograss_area.dart';
import 'package:gigafaucet/features/reward/presentation/widgets/status_reward_widget.dart';
import 'package:gigafaucet/features/reward/presentation/widgets/status_rewards_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardDialog extends ConsumerWidget {
  const RewardDialog({super.key});

  double _dialogHeight(BuildContext context) =>
      MediaQuery.of(context).size.height <= 700
          ? MediaQuery.of(context).size.height * 0.9
          : 800;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(getRewardNotifierProvider);
    final isLoading = state.status == GetRewardStatus.loading;
    final error = state.error;
    final data = state.userLevelState;
    final isViewAll = state.isViewAll;

    final height = _dialogHeight(context);

    return DialogBgWidget(
      isInitLoading: isLoading,
      isOverlayLoading: false,
      padding: EdgeInsets.zero,
      dialogHeight: height,
      dividerColor: const Color(0xFF003248), //TODO: to use from schma color
      title: LocalizationHelper(context).translate("rewards_title"),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ---------------------------
          // LOADING
          // ---------------------------

          // ---------------------------
          // ERROR
          // ---------------------------
          if (!isLoading && error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _errorWidget(error),
            ),

          SliverToBoxAdapter(
            child: SizedBox(height: 27),
          ),
          // ---------------------------
          // SUCCESS CONTENT
          // ---------------------------
          if (!isLoading && error == null && data != null && !isViewAll)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// DESCRIPTION
                    CommonRichTextWithIcon(
                      prefixText: LocalizationHelper(context)
                          .translate("reward_description_prefix"),
                      boldNumber: "5",
                      suffixText: LocalizationHelper(context)
                          .translate("reward_description_suffix"),
                      iconPath: AppLocalImages.coin,
                    ),
                    RewardXpPrograssArea(userlevelState: data),
                    StatusRewardsWidget(
                      selectedTier: state.selectedLevel,
                      tiers: state.levels,
                      onTierSelected: (matchedLevel) {
                        ref
                            .read(getRewardNotifierProvider.notifier)
                            .selectLevel(matchedLevel.id);
                      },
                    )
                  ],
                ),
              ),
            ),

          if (!isLoading && error == null && data != null)
            StatusRewardsTableSliver(
              level: state.levels
                  .firstWhere((level) => level.id == state.selectedLevel),
              currentLevel: data.level,
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}

Widget _errorWidget(String error) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 32,
    ),
    child: Center(
      child: CommonText.bodyLarge(
        error,
        color: Colors.redAccent,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
