import 'package:cointiply_app/core/common/dialog_gradient_backgroud.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_dialog_header.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_xp_prograss_area.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_rewards_table.dart';
import 'package:flutter/material.dart';

class RewardDialog extends StatefulWidget {
  const RewardDialog({super.key});

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {
  double _getDialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= 600) return width;
    if (width <= 1100) return width * 0.8;
    return 650;
  }

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height <= 700) return height * 0.9;
    return 800;
  }

  @override
  Widget build(BuildContext context) {
    final width = _getDialogWidth(context);
    final height = _getDialogHeight(context);
    final isMobile = context.isMobile;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          DialogGradientBackground(width: width, height: height),
          Container(
            width: width,
            height: height,
            padding:
                EdgeInsets.only(top: 32, bottom: context.isMobile ? 26 : 40),
            child: SizedBox(
              height: height,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RewardDialogHeader(),
                    SizedBox(height: isMobile ? 15 : 25),
                    RewardXpPrograssArea(),
                    StatusRewardsWidget(selectedTier: "bronze"),
                    StatusRewardsTable(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
