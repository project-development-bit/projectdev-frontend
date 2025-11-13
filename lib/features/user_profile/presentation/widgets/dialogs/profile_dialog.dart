import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_gradient_backgroud.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sections/coins_history_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sections/statistics_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cointiply_app/core/common/close_square_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  int selectedTab = 0;
  double _getDialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= 600) return width; // mobile → full width
    if (width <= 1100) return width * 0.8; // tablet → 80%
    return width * 0.4; // desktop → 40%
  }

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height <= 700) return height * 0.9;
    return 680;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer(builder: (context, ref, _) {
                        final currentUserState = ref.watch(currentUserProvider);
                        return CommonText.titleMedium(
                          currentUserState.user?.name ?? "Unknown User",
                          color: colorScheme.onPrimary,
                        );
                      }),
                      CloseSquareButton(onTap: () => Navigator.pop(context)),
                    ],
                  ),
                ),

                Divider(
                  color: colorScheme.outline,
                  height: 40,
                  thickness: 1,
                ),

                const SizedBox(height: 20),

                // --------------------------
                // Avatar + Badge + Info Row
                // --------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserProfileImageWidget(size: 50),
                      const SizedBox(width: 24),

                      // Level Badge
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: const AssetImage(
                                "assets/images/levels/bronze.png"),
                            width: 40,
                          ),
                          const SizedBox(height: 5),
                          CommonText.bodyMedium(
                            localizations
                                    ?.translate('profile_level_bronze_1') ??
                                'Bronze 1',
                            color: colorScheme.onPrimary,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Messages + Location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/icons/message.svg",
                                    width: 38,
                                    height: 38,
                                  ),
                                  const SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText.labelLarge("1542",
                                          color: colorScheme.onPrimary),
                                      CommonText.labelSmall(
                                        localizations?.translate(
                                                'profile_message') ??
                                            "Message",
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/icons/location.svg",
                                    width: 38,
                                    height: 38,
                                  ),
                                  const SizedBox(width: 4),
                                  CommonText.labelLarge(
                                    "Thailand",
                                    color: colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          CommonText.labelSmall(
                            localizations?.translate('profile_created_days') ??
                                "Created 5 Days Ago",
                            color: colorScheme.onSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Tabs
                ProfileTabs(onTabChanged: (int i) {
                  setState(() {
                    selectedTab = i;
                  });
                }),

                const SizedBox(height: 25),
                Expanded(
                  child: SingleChildScrollView(
                    child: selectedTab == 0
                        ? const StatisticsSection()
                        : const CoinsHistorySection(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTabs extends StatefulWidget {
  final void Function(int index)? onTabChanged;

  const ProfileTabs({super.key, this.onTabChanged});

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: CustomButtonWidget(
              title: localizations?.translate('profile_statistics') ??
                  "Statistics",
              isActive: selected == 0,
              onTap: () {
                setState(() => selected = 0);
                widget.onTabChanged?.call(0);
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: CustomButtonWidget(
              title: localizations?.translate('profile_coins_earned_history') ??
                  "Coins Earned History",
              isActive: selected == 1,
              onTap: () {
                setState(() => selected = 1);
                widget.onTabChanged?.call(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
