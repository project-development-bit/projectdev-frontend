import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/actual_faucet_title.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/event_daily_streak_resets.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/faucet_status_day_list_widget.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/faucet_status_progress_bar.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/next_faucet_widget.dart';
import 'package:gigafaucet/features/user_profile/presentation/widgets/dialogs/dialog_scaffold_widget.dart';
import 'package:gigafaucet/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showYourFaucetDialog(BuildContext context, Function onClaimTap) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) => DialogScaffoldWidget(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: YourFaucetDialog(onClaimTap: () {
          context.pop();
          onClaimTap();
        })),
  );
}

class YourFaucetDialog extends ConsumerStatefulWidget {
  const YourFaucetDialog({super.key, required this.onClaimTap});
  final Function onClaimTap;
  @override
  ConsumerState<YourFaucetDialog> createState() => _YourFaucetDialogState();
}

class _YourFaucetDialogState extends ConsumerState<YourFaucetDialog> {
  int selectedTab = 0;

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (context.isTablet) return height * 0.9;
    return 680;
  }

  @override
  Widget build(BuildContext context) {
    final height = _getDialogHeight(context);
    final currentUserState = ref.watch(getFaucetNotifierProvider);
    return DialogBgWidget(
      isInitLoading: currentUserState.isLoading,
      isOverlayLoading: false,
      dialogHeight: height,
      title: context.translate("your_faucet"),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding:
              EdgeInsets.symmetric(horizontal: context.isMobile ? 10 : 10.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: [
            SizedBox(height: 24),
            ActualFaucetTitle(
              isColumn: context.isMobile,
            ),
            SizedBox(height: 17),
            NextFaucetWidget(
              onClaimTap: widget.onClaimTap,
            ),
            SizedBox(height: 17),
            CommonText.titleLarge(
              context.translate("event_daily_streak_faucet"),
              fontSize: 20.0,
            ),
            CommonText.bodyLarge(
              context.translate("event_earn_coins_continue_streak"),
              color: Color(0xFF98989A),
            ),
            SizedBox(height: 24),
            FaucetStatusProgressBar(),
            SizedBox(height: 24),
            FaucetStatusDayListWidget(),
            SizedBox(height: 16),
            EventDailyStreakResets(),
            SizedBox(height: 67),
          ]),
        ),
      ),
    );
  }
}
