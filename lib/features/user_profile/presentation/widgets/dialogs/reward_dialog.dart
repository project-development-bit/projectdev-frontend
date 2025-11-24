import 'package:cointiply_app/core/common/common_rich_text_with_icon.dart';
import 'package:cointiply_app/core/common/dialog_gradient_backgroud.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/reward/presentation/providers/reward_provider.dart';
import 'package:cointiply_app/features/reward/presentation/providers/reward_state.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_dialog_header.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_xp_prograss_area.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_rewards_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardDialog extends StatelessWidget {
  const RewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final width = _dialogWidth(context);
    final height = _dialogHeight(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          DialogGradientBackground(width: width, height: height),
          _RewardDialogContent(width: width, height: height),
        ],
      ),
    );
  }

  double _dialogWidth(BuildContext context) =>
      context.isMobile ? MediaQuery.of(context).size.width : 650;

  double _dialogHeight(BuildContext context) =>
      MediaQuery.of(context).size.height <= 700
          ? MediaQuery.of(context).size.height * 0.9
          : 800;
}

class _RewardDialogContent extends ConsumerWidget {
  final double width;
  final double height;

  const _RewardDialogContent({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.isMobile;
    final state = ref.watch(getRewardNotifierProvider);
    final isLoading = state.status == GetRewardStatus.loading;
    final error = state.error;
    final data = state.rewards?.data;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(top: 32, bottom: isMobile ? 26 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RewardDialogHeader(),
          SizedBox(height: isMobile ? 15 : 25),
          Expanded(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ---------------------------
                // LOADING
                // ---------------------------
                if (isLoading)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _loadingWidget(),
                  ),

                // ---------------------------
                // ERROR
                // ---------------------------
                if (!isLoading && error != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _errorWidget(error),
                  ),

                // ---------------------------
                // SUCCESS CONTENT
                // ---------------------------
                if (!isLoading && error == null && data != null)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 27),

                        /// DESCRIPTION
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 26 : 35),
                          child: CommonRichTextWithIcon(
                            prefixText: LocalizationHelper(context)
                                .translate("reward_description_prefix"),
                            boldNumber: "5",
                            suffixText: LocalizationHelper(context)
                                .translate("reward_description_suffix"),
                            iconPath: "assets/images/rewards/coin.png",
                          ),
                        ),
                        RewardXpPrograssArea(data: data),
                        StatusRewardsWidget(
                          selectedTier: data.currentTier,
                          tiers: data.tiers,
                        )
                      ],
                    ),
                  ),
                if (!isLoading && error == null && data != null)
                  StatusRewardsTableSliver(levels: data.levels),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _loadingWidget() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 24),
    child: Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.white,
      ),
    ),
  );
}

Widget _errorWidget(String error) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 24,
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
