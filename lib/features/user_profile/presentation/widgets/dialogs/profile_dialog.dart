import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/extensions/date_extensions.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_history_request.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_statistics_request.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/get_earnings_history_notifier.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/get_earnings_statistics_notifier.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/features/localization/data/helpers/app_localizations.dart';
import 'package:cointiply_app/features/user_profile/data/enum/user_level.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/overview/avatar_badge_info.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sections/coins_history_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sections/statistics_section.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDialog extends ConsumerStatefulWidget {
  const ProfileDialog({super.key});

  @override
  ConsumerState<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends ConsumerState<ProfileDialog> {
  int selectedTab = 0;

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (context.isTablet) return height * 0.9;
    return 680;
  }

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(earningsStatisticsNotifierProvider.notifier)
          .fetchStatistics(const EarningsStatisticsRequest());
      ref.read(earningsHistoryNotifierProvider.notifier).fetchEarningsHistory(
          const EarningsHistoryRequestModel(page: 1, limit: 20, days: 30));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = _getDialogHeight(context);
    final isTablet = context.isTablet;
    final isMobile = context.isMobile;
    final currentUserState = ref.watch(currentUserProvider);

    final selectedStatisticsState =
        ref.watch(earningsStatisticsNotifierProvider);
    final selectedEarningsHistoryState =
        ref.watch(earningsHistoryNotifierProvider);
    final earningsHistoryNotifier =
        ref.read(earningsHistoryNotifierProvider.notifier);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return DialogBgWidget(
      isInitLoading: currentUserState.isLoading ||
          selectedStatisticsState.isLoading ||
          selectedEarningsHistoryState.isLoading,
      isOverlayLoading: false,
      dialogHeight: height,
      title: currentUserState.user?.name ?? "Unknown User",
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: context.isMobile ? 10.5 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              AvatarBadgeInfo(
                levelImage: currentUserState.user?.currentStatus.asset ??
                    UserLevel.bronze.asset,
                levelText: currentUserState.user?.currentStatus.label(
                      appLocalizations,
                    ) ??
                    UserLevel.bronze.label(appLocalizations),
                messageCount: "1542",
                location: currentUserState.user?.countryName ?? "Unknown",
                createdText: context
                    .translate(
                      "profile_created_days",
                    )
                    .replaceAll(
                      '{days}',
                      DateTime.parse(currentUserState.user?.createdAt
                                  .toIso8601String() ??
                              DateTime.now().toIso8601String())
                          .timeAgoDaysOnly(),
                    ),
              ),
              SizedBox(height: isMobile || isTablet ? 31 : 40),
              ProfileTabs(
                onTabChanged: (i) => setState(() => selectedTab = i),
              ),
              SizedBox(height: isMobile || isTablet ? 16 : 23),
              selectedTab == 0
                  ? StatisticsSection(state: selectedStatisticsState)
                  : CoinsHistorySection(
                      state: selectedEarningsHistoryState,
                      loadMore: () {
                        earningsHistoryNotifier.loadMore();
                      },
                      onPageChange: (newPage) {
                        earningsHistoryNotifier.changePage(newPage);
                      },
                      onLimitChange: (newLimit) {
                        earningsHistoryNotifier.changeLimit(newLimit);
                      },
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = context.isMobile;
        return isMobile
            ? Column(
                children: [
                  CustomButtonWidget(
                    isOutlined: true,
                    title: context.translate('profile_statistics'),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    isActive: selected == 0,
                    onTap: () {
                      setState(() => selected = 0);
                      widget.onTabChanged?.call(0);
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomButtonWidget(
                    isOutlined: true,
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
                      isOutlined: true,
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
                      isOutlined: true,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      title: context.translate('profile_coins_earned_history'),
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
    );
  }
}
