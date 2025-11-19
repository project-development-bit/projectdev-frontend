import 'package:cointiply_app/core/common/dialog_gradient_backgroud.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/core/theme/app_typography.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_rewards_table.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/common/close_square_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';

class RewardDialog extends StatefulWidget {
  const RewardDialog({super.key});

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {
  int selectedTab = 0;

  double _getDialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= 600) return width; // Mobile → full width
    if (width <= 1100) return width * 0.8; // Tablet → 80%
    return 650; //Fixed width for desktop
  }

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height <= 700) return height * 0.9;
    return 680;
  }

  @override
  Widget build(BuildContext context) {
    final width = _getDialogWidth(context);
    final height = _getDialogHeight(context);
    final colorScheme = Theme.of(context).colorScheme;

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
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: height,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText.headlineSmall(
                            "Rewards",
                            color: colorScheme.onPrimary,
                          ),
                          CloseSquareButton(
                              onTap: () => Navigator.pop(context)),
                        ],
                      ),
                    ),
                    Divider(
                      color: const Color(0xFF003248),
                      height: 40,
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: RichText(
                        text: TextSpan(
                          style:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? AppTypography.bodyMediumDark
                                      : AppTypography.bodyMedium)
                                  .copyWith(
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  "Level up as you earn & unlock new rewards. You earn 1XP point for every ",
                            ),
                            const TextSpan(
                              text: "5 ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(
                                "assets/images/rewards/coin.png",
                                width: 15,
                              ),
                            ),
                            const TextSpan(text: " earned."),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/levels/bronze.png",
                            height: 50,
                            width: 42,
                            fit: BoxFit.contain,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 31),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "78",
                                          style: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? AppTypography
                                                      .titleMediumDark
                                                  : AppTypography.titleMedium)
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00A0DC),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "%",
                                          style: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? AppTypography
                                                      .titleMediumDark
                                                  : AppTypography.titleMedium)
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme
                                                .onPrimary, // Matches Figma
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: 15,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 78,
                                            child: Container(
                                                decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Color(
                                                      0xFFB28F0C), //TODO use from theme
                                                  width: 3,
                                                ),
                                              ),
                                              color: colorScheme.primary,
                                            )),
                                          ),
                                          Expanded(
                                            flex: 22,
                                            child: Container(
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "2,452 ",
                                          style: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? AppTypography
                                                      .titleMediumDark
                                                  : AppTypography.titleMedium)
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00A0DC),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "XP points to next level",
                                          style: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? AppTypography
                                                      .titleMediumDark
                                                  : AppTypography.titleMedium)
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme
                                                .onPrimary, // Matches Figma
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CommonText.titleMedium("Lvl 20",
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onPrimary),
                        ],
                      ),
                    ),
                    StatusRewardsWidget(
                      selectedTier: "bronze",
                    ),
                    StatusRewardsTable(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
