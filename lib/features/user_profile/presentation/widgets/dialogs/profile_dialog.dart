import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_gradient_backgroud.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/overview/avatar_badge_info.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sections/coins_history_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sections/statistics_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    if (context.isMobile) return width; // Mobile → full width
    if (context.isTablet) return width * 0.8; // Tablet → 80%
    return 650; //Fixed width for desktop
  }

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (context.isTablet) return height * 0.9;
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
                          Consumer(builder: (context, ref, _) {
                            final currentUserState =
                                ref.watch(currentUserProvider);
                            return CommonText.headlineSmall(
                              currentUserState.user?.name ?? "Unknown User",
                              color: colorScheme.onPrimary,
                            );
                          }),
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
                    const SizedBox(height: 24),
                    AvatarBadgeInfo(
                      levelImage: "assets/images/levels/bronze.png",
                      levelText: context.translate("profile_level_bronze_1"),
                      messageCount: "1542",
                      location: "Thailand",
                      createdText: context.translate("profile_created_days"),
                    ),
                    const SizedBox(height: 40),
                    ProfileTabs(
                      onTabChanged: (i) => setState(() => selectedTab = i),
                    ),
                    const SizedBox(height: 23),
                    selectedTab == 0
                        ? const StatisticsSection()
                        : const CoinsHistorySection(),
                    const SizedBox(height: 20),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = context.isMobile;
          return isMobile
              ? Column(
                  children: [
                    CustomButtonWidget(
                      title: context.translate('profile_statistics'),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      isActive: selected == 0,
                      onTap: () {
                        setState(() => selected = 0);
                        widget.onTabChanged?.call(0);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButtonWidget(
                      title: context.translate('profile_coins_earned_history'),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      isActive: selected == 1,
                      onTap: () {
                        setState(() => selected = 1);
                        widget.onTabChanged?.call(1);
                      },
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: CustomButtonWidget(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        title: context.translate('profile_statistics'),
                        isActive: selected == 0,
                        onTap: () {
                          setState(() => selected = 0);
                          widget.onTabChanged?.call(0);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButtonWidget(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        title:
                            context.translate('profile_coins_earned_history'),
                        isActive: selected == 1,
                        onTap: () {
                          setState(() => selected = 1);
                          widget.onTabChanged?.call(1);
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
