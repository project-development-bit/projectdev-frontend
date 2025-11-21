import 'package:cointiply_app/core/common/dialog_gradient_backgroud.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/reward/data/models/response/reward_data.dart';
import 'package:cointiply_app/features/reward/presentation/providers/reward_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_dialog_header.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_xp_prograss_area.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_rewards_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardDialog extends ConsumerWidget {
  const RewardDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardState = ref.watch(rewardProvider);
    final rewards = rewardState.rewards?.data;

    final isLoading = rewardState.isLoading;
    final error = rewardState.error;

    final width = _dialogWidth(context);
    final height = _dialogHeight(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          DialogGradientBackground(width: width, height: height),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (!isLoading && error != null)
            Center(
              child: CommonText.bodyLarge(
                error,
                color: Colors.redAccent,
              ),
            ),
          if (!isLoading && error == null && rewards != null)
            _RewardDialogContent(
              width: width,
              height: height,
              data: rewards,
            ),
        ],
      ),
    );
  }

  double _dialogWidth(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600
          ? MediaQuery.of(context).size.width
          : 650;

  double _dialogHeight(BuildContext context) =>
      MediaQuery.of(context).size.height <= 700
          ? MediaQuery.of(context).size.height * 0.9
          : 800;
}

class _RewardDialogContent extends StatelessWidget {
  final double width;
  final double height;
  final RewardData data;

  const _RewardDialogContent({
    required this.width,
    required this.height,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(top: 32, bottom: isMobile ? 26 : 40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RewardDialogHeader(),
            SizedBox(height: isMobile ? 15 : 25),
            RewardXpPrograssArea(data: data),
            StatusRewardsWidget(
                selectedTier: data.currentTier, tiers: data.tiers),
            StatusRewardsTable(levels: data.levels),
          ],
        ),
      ),
    );
  }
}
